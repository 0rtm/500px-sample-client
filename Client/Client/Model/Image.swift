//
//  Image.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

struct Image: Decodable {

    let httpsURLString: String
    let size: Int

    var httpsURL: URL? {
        return URL(string: httpsURLString)
    }

    enum CodingKeys: String, CodingKey {
        case httpsURLString = "https_url"
        case size
    }

}
