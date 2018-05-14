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
    let camera: String?
    let lens: String?
    let width: Int
    let height: Int
    let iso: String?
    let location: String?
    let aperture: String?
    let shutterSpeed: String?
    let focalLength: String?
    let timesViewed: Int
    let images: [Image]
    let user: User

    enum CodingKeys: String, CodingKey {
        case shutterSpeed = "shutter_speed"
        case timesViewed = "times_viewed"
        case focalLength = "focal_length"
        case id
        case name
        case camera
        case lens
        case width
        case height
        case iso
        case location
        case aperture
        case images
        case user
    }
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

    var sections: [Section] {
        let allSections = [photoInfoSection, cameraSection , userSection]
        return allSections.compactMap({$0})
    }

    var photoInfoSection: Section {
        let items = [("Name", name),
                     ("Views", "\(timesViewed)")]

        return Section(title: "Photo details", items: items)
    }

    var cameraSection: Section? {

        var items: [TableItem] = []

        if let _camera = camera {
            items.append(("Camera", _camera))
        }
        if let _lens = lens {
            items.append(("Lens", _lens))
        }

        if let _focalLenght = focalLength {
            items.append(("Focal lenght", "\(_focalLenght)mm"))
        }

        if let _shutterSpeed = shutterSpeed {
            items.append(("Shutter speed", "\(_shutterSpeed)s"))
        }

        if let _iso = iso {
             items.append(("ISO", "ISO\(_iso)"))
        }

        if items.count > 0 {
            return Section(title: "Camera", items: items)
        } else {
            return nil
        }
    }

    var userSection: Section {
        let items = [("User name", user.userName)]
        return Section(title: "User", items: items)
    }
}

