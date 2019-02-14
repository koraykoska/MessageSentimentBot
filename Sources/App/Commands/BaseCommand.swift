//
//  BaseCommand.swift
//  App
//
//  Created by Koray Koska on 24.01.19.
//

import Foundation
import TelegramBot

protocol BaseCommand {

    static var command: String { get }

    static func isParsable(message: TelegramMessage, botName: String) -> Bool

    var message: TelegramMessage { get }

    init(message: TelegramMessage, token: String, apiKey: String)

    func run() throws
}

extension BaseCommand {

    static func isParsable(message: TelegramMessage, botName: String) -> Bool {
        guard let text = message.text else {
            return false
        }

        return text == command || text == "\(command)\(botName)"
    }
}
