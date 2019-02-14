//
//  BaseCallbackQuery.swift
//  App
//
//  Created by Koray Koska on 31.01.19.
//

import Foundation
import TelegramBot

protocol BaseCallbackQuery {

    static var callbackData: String { get }

    static func isParsable(callbackQuery: TelegramCallbackQuery) -> Bool

    var callbackQuery: TelegramCallbackQuery { get }

    init(callbackQuery: TelegramCallbackQuery, token: String, apiKey: String)

    func run() throws
}

extension BaseCallbackQuery {

    static func isParsable(callbackQuery: TelegramCallbackQuery) -> Bool {
        guard let data = callbackQuery.data else {
            return false
        }
        return data == callbackData
    }
}
