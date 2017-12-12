//
//  URLSession+JSONDecodable.swift
//  Bitso
//
//  Created by Julio Cesar Guzman Villanueva on 12/10/17.
//  Copyright © 2017 Julio Cesar Guzman Villanueva. All rights reserved.
//

import Foundation

extension URLSession {
    func decodeJSONTask<T: Decodable>(from endpoint: Endpoint,
                                      completion: @escaping (T?, BitsoError?) -> () ) -> URLSessionTask {
        var components = URLComponents.bitso
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        assert(components.url != nil, "URL components couldn't be formed. Please check your URLComponents.")
        let request = URLRequest(url: components.url!)
        let task = dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            completion(result, error?.error)
        }
        return task
    }
}
