//
//  GoogleMessageSentimentRequest.swift
//  App
//
//  Created by Koray Koska on 14.02.19.
//

import Foundation

struct GoogleMessageSentimentRequest: Codable {

    let document: Document

    let encodingType: EncodingType

    struct Document: Codable {

        let type: DocumentType

        let language: String?

        let content: String

        enum DocumentType: String, Codable {

            case unspecified = "TYPE_UNSPECIFIED"

            case plainText = "PLAIN_TEXT"

            case html = "HTML"
        }
    }

    enum EncodingType: String, Codable {

        case none = "NONE"

        case utf8 = "UTF8"

        case utf16 = "UTF16"

        case utf32 = "UTF32"
    }
}
