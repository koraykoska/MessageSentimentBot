//
//  MessageParser.swift
//  App
//
//  Created by Koray Koska on 14.02.19.
//

import TelegramBot
import TelegramBotPromiseKit
import PromiseKit
import Dispatch

/// May only be called if no command is able to parse the message.
class MessageParser {

    let message: TelegramMessage

    let token: String

    let botName: String

    let apiKey: String

    required init(message: TelegramMessage, token: String, botName: String, apiKey: String) {
        self.message = message
        self.token = token
        self.botName = botName
        self.apiKey = apiKey
    }

    func run() throws {
        let messageText: String?
        let replyId: Int
        if let reply = message.replyToMessage, message.text == botName {
            // Analyze reply
            messageText = reply.text
            replyId = reply.messageId
        } else if message.chat.type == .privateChat {
            // Analyze message
            messageText = message.text
            replyId = message.messageId
        } else {
            return
        }

        guard let text = messageText else {
            return
        }

        let doc = GoogleMessageSentimentRequest.Document.init(type: .plainText, language: nil, content: text)
        let request = GoogleMessageSentimentRequest(document: doc, encodingType: .utf8)

        let queue = DispatchQueue(label: "MessageParser")
        firstly {
            GoogleMessageSentimentApi(apiKey: apiKey).sentiment(request: request)
        }.done(on: queue) { response in
            let sendApi = TelegramSendApi(token: self.token, provider: SnakeTelegramProvider(token: self.token))

            let text = self.generateResponse(res: response)

            let chatId = self.message.chat.id
            sendApi.sendMessage(message: TelegramSendMessage(chatId: chatId, text: text, parseMode: .markdown, replyToMessageId: replyId))
        }.catch(on: queue) { error in
            print("*** ERROR ***")
            print(error)

            let sendApi = TelegramSendApi(token: self.token, provider: SnakeTelegramProvider(token: self.token))
            let text = "This is not a language."
            sendApi.sendMessage(message: TelegramSendMessage(chatId: self.message.chat.id, text: text, replyToMessageId: replyId))
        }
    }

    private func generateResponse(res: GoogleMessageSentimentResponse) -> String {
        var response = "*SENTIMENT ANALYSIS* (\(res.language))"

        let isPositive: Bool
        if res.documentSentiment.score >= 0 {
            response += "\n\n• The overall sentiment of this message is positive"
            isPositive = true
        } else {
            response += "\n\n• The overall sentiment of this message is negative"
            isPositive = false
        }

        response += " (\(Int(res.documentSentiment.score * 100))%)."

        /*
         var oppositeCount = 0
         for sentence in res.sentences {
         if isPositive && sentence.sentiment.score < 0 {
         oppositeCount += 1
         } else if !isPositive && sentence.sentiment.score >= 0 {
         oppositeCount += 1
         }
         }
         let variation: Double = Double(oppositeCount) / Double(res.sentences.count)
         */
        var average: Double = 0
        for sentence in res.sentences {
            average += sentence.sentiment.score
        }
        average = res.sentences.count > 0 ? average / Double(res.sentences.count) : 0

        let variation = normalDistribution(μ: average, σ: 0.5)(0.5)

        response += "\n• Within the message the sentiment varies around \(Int(variation * 100))%."

        if variation > 0.3 {
            response += "\n\n_> Note: Be careful! Messages with a big sentiment variation often imply that the person writing the message is angry or annoyed. It may also imply some kind of schizophrenic behavior (this is no medical advice)._"
        }

        return response
    }
}
