//
//  GoogleMessageSentimentResponse.swift
//  App
//
//  Created by Koray Koska on 14.02.19.
//

import Foundation

struct GoogleMessageSentimentResponse: Codable {

    let documentSentiment: Sentiment

    let language: String

    let sentences: [Sentence]

    struct Sentiment: Codable {

        let magnitude: Double

        let score: Double
    }

    struct Sentence: Codable {

        let text: TextSpan

        let sentiment: Sentiment

        struct TextSpan: Codable {

            let content: String

            let beginOffset: Int
        }
    }
}
