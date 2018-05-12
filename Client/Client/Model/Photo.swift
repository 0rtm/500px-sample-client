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
    let iso: String?

    let images: [Image]
}

extension Photo {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }

    var aspectRatio: Double {
        return Double(width)/Double(height)
    }

    var imageURL: URL? {
         return images.first?.httpsURL
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo: TablePresentable {

    func items() -> [TablePresentable.TableItem] {
        let mirror = Mirror.init(reflecting: self)
        let items = mirror.children.compactMap( { ($0.label!, String(describing: $0.value)) } )
        return items
    }

}

