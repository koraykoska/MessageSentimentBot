//
//  SnakeCaser.swift
//  App
//
//  Created by Koray Koska on 01.02.19.
//

import Foundation

class SnakeCaser {

    /// Call this only on background threads
    static func snakeCase(json: String, callback: @escaping (String?) -> ()) {
        let urlStr = "http://127.0.0.1:8888/snakeCase"

        guard let body = json.data(using: .utf8) else {
            callback(nil)
            return
        }

        guard let url = URL(string: urlStr) else {
            callback(nil)
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = body
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession(configuration: .default)

        let queue = DispatchQueue(label: "AppSnakeCaser")

        queue.async {
            let task = session.dataTask(with: req) { data, urlResponse, error in
                guard let urlResponse = urlResponse as? HTTPURLResponse, let data = data, error == nil else {
                    callback(nil)
                    return
                }

                let status = urlResponse.statusCode
                guard status >= 200 && status < 300 else {
                    callback(nil)
                    return
                }

                let snaked = String(data: data, encoding: .utf8)
                callback(snaked)
            }
            task.resume()
        }
    }
}
