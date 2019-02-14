//
//  GoogleMessageSentimentApi.swift
//  App
//
//  Created by Koray Koska on 14.02.19.
//

import Foundation
import PromiseKit
import Dispatch

struct GoogleMessageSentimentApi {

    let headers: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var baseUrl: String {
        return "https://language.googleapis.com/v1beta2/documents:analyzeSentiment?key=\(apiKey)"
    }

    let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    enum Error: Swift.Error {

        case requestFailed

        case serverError

        case decodeFailed
    }

    func sentiment(request: GoogleMessageSentimentRequest) -> Promise<GoogleMessageSentimentResponse> {
        return Promise { seal in
            self.sentiment(request: request, response: seal.resolve)
        }
    }

    func sentiment(request: GoogleMessageSentimentRequest, response: @escaping (GoogleMessageSentimentResponse?, Error?) -> ()) {
        let queue = DispatchQueue(label: "AppGoogleVisionApi", attributes: .concurrent)

        queue.async {
            guard let url = URL(string: self.baseUrl) else {
                let err = Error.requestFailed
                response(nil, err)
                return
            }

            let body: Data
            do {
                body = try self.encoder.encode(request)
            } catch {
                let err = Error.requestFailed
                response(nil, err)
                return
            }

            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.httpBody = body
            for (k, v) in self.headers {
                req.addValue(v, forHTTPHeaderField: k)
            }

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: req) { data, urlResponse, error in
                guard let urlResponse = urlResponse as? HTTPURLResponse, let data = data, error == nil else {
                    let err = Error.serverError
                    response(nil, err)
                    return
                }

                let status = urlResponse.statusCode
                guard status >= 200 && status < 300 else {
                    let err = Error.serverError
                    response(nil, err)
                    return
                }

                do {
                    let res = try self.decoder.decode(GoogleMessageSentimentResponse.self, from: data)

                    // We got the Result
                    response(res, nil)
                } catch {
                    response(nil, Error.decodeFailed)
                    return
                }
            }
            task.resume()
        }
    }
}
