//
//  Networking.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-09.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkingError: Error {
    case genericError(errorDesc: String)
    case serializationError()
}

struct RequestProperties {
    let path: String
    let method: HTTPMethod
    let headers: HTTPHeaders?
    let params: Parameters?
}

struct Networking {

    fileprivate let baseURL = URL(string: "https://api.500px.com")

    func request<T>(requestProperties: RequestProperties, completion: @escaping (Error?,T?)->()) where T: Decodable {

        guard let URL = URL(string: requestProperties.path, relativeTo: baseURL) else {
            fatalError("Invalid request url")
        }

        Alamofire.request(URL, method: requestProperties.method, parameters: requestProperties.params, headers: requestProperties.headers)
            .validate()
            .responseJSON { (response) in

                guard response.result.isSuccess else {
                    let error = NetworkingError.genericError(errorDesc: response.error.debugDescription)
                    completion(error, nil)
                    return
                }

                let decoder = JSONDecoder()

                guard let data = response.data else {
                    let error = NetworkingError.genericError(errorDesc: "No data")
                    completion(error, nil)
                    return
                }

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(nil, decoded)
                } catch {
                    let error = NetworkingError.serializationError()
                    completion(error, nil)
                }
        }
    }

}
