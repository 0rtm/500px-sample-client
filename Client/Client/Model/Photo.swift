//
//  Photo.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Decodable {

    let id: UInt64
    let name: String
    let width: Int
    let height: Int

    let images: [Image]
}

extension Photo {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }

    var aspectRatio: Double {
        return Double(width)/Double(height)
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }

}
