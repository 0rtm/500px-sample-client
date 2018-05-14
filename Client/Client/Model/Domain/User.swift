//
//  User.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-13.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

struct User: Decodable {
    let userName: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
    }
}
