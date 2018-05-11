//
//  Photos.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewModel: NSObject {


    var photos: [Photo] = []

    func loadPage(completion: @escaping ()->()) {
        let networking = Networking()
        networking.getPage{[weak self] (error, page) in

            guard error == nil else {
                print(error.debugDescription)
                fatalError()
            }

            guard let _page = page else {return}

            self?.photos = _page.photos
            completion()
        }
    }

    func loadPhotos() {

    }

}


