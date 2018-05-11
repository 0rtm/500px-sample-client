//
//  Photo.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

struct Photo: Decodable {

    let id: UInt64
    let name: String
    let images: [Image]
    
}
