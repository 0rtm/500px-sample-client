//
//  Request.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-13.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

struct Request {

    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getPhotos(pageNumber: Int, completion : @escaping (Error?, Page?)->()) {
        let params = Route.getPhotos(page: pageNumber).requestProperties
        networking.request(requestProperties: params, completion: completion)
    }

}
