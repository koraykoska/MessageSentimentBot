//
//  StartCommand.swift
//  App
//
//  Created by Koray Koska on 31.01.19.
//

import Vapor
import TelegramBot
import TelegramBotPromiseKit
import PromiseKit

class StartCommand: BaseCommand {

    static let command: String = "/start"

    let message: TelegramMessage

    let token: String

    let apiKey: String

    required init(message: TelegramMessage, token: String, apiKey: String) {
        self.message = message
        self.token = token
        self.apiKey = apiKey
    }

    func run() throws {
        let chat = message.chat
        let chatId = chat.id
        let chatTitle = chat.title
        let chatFirstName = chat.firstName

        var chatName = "1 Larry"
        if let chatTitle = chatTitle {
            chatName = chatTitle
        } else if let chatFirstName = chatFirstName {
            chatName = chatFirstName
        }

        let text = "Hi \(chatName)! Please feel free to and forward me a message to be analyzed. (You can also reply to a message and tag me to analyze it in groups)"

        let sendApi = TelegramSendApi(token: token, provider: SnakeTelegramProvider(token: token))

        sendApi.sendMessage(message: TelegramSendMessage(chatId: chatId, text: text))
    }
}
