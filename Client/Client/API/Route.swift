//
//  Requests.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-13.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

enum Route {

    case getPhotos(page: Int)

    fileprivate var consumerKey: String {
        return "L248TO2cgEpTMw5mUdo74ntKIvR4fOsIBeCGJFBV"
    }

    var requestProperties: RequestProperties {
        switch self {
            
        case .getPhotos(let page):
            let path = "v1/photos"
            let params = ["feature": "popular", "image_size": "4", "page": String(page), "consumer_key": consumerKey]

            return RequestProperties(path: path, method: .get, headers: nil, params: params)
        }
    }

}
