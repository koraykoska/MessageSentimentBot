//
//  CustomConfigService.swift
//  App
//
//  Created by Koray Koska on 24.01.19.
//

import Foundation
import Vapor

public struct CustomConfigService: Service {

    public let telegramToken: String

    public let botName: String

    public let googleNLPApiKey: String
}
