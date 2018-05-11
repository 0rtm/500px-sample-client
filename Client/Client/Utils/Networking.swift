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

struct Networking {

    let consumerKey = "L248TO2cgEpTMw5mUdo74ntKIvR4fOsIBeCGJFBV"

    func getPage(completion : @escaping (Error?, Page?)->()) {

        let url = URL(string: "https://api.500px.com/v1/photos")!
        let params = ["image_size": "4",
                      "consumer_key": consumerKey]

        Alamofire.request(url, method: .get, parameters: params, headers: nil)
            .validate()
            .responseJSON { (response) in

                print(response)

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
                    let page = try decoder.decode(Page.self, from: data)
                    completion(nil, page)
                } catch {
                    let error = NetworkingError.serializationError()
                    completion(error, nil)
                }
        }
    }

}
