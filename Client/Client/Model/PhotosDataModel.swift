//
//  PhotosDataModel.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

class PhotosDataModel {

    var selectedIndex: IndexPath?

    fileprivate var currentPage = 1
    fileprivate let loadingLimit = 100

    fileprivate let networking = Networking()
    fileprivate let request: Request

    fileprivate var photos: [Photo] = []

    init() {
        request = Request(networking: networking)
    }

    func loadPhotos(completion: @escaping ([Photo])->()) {
        loadPage(completion: completion)
    }

    func loadMorePhotos(completion: @escaping ([Photo])->()) {
        loadMore(completion: completion)
    }

    func storedPhotos(completion: @escaping ([Photo])->()) {
        completion(photos)
    }

    fileprivate func loadPage(completion: @escaping ([Photo])->()) {
        loadPage(pageNumber: currentPage, completion: completion)
    }

    fileprivate func loadMore(completion: @escaping ([Photo])->()) {
        currentPage += 1

        if currentPage > loadingLimit {
            completion(photos)
            return
        }

        loadPage(pageNumber: currentPage, completion: completion)
    }

    func loadPage(pageNumber: Int, completion: @escaping ([Photo])->()) {

        request.getPhotos(pageNumber: pageNumber){[weak self] (error, page) in

            guard error == nil else {
                print(error.debugDescription)
                completion([])
                return
            }

            guard let _page = page, let strongSelf = self else {return}

            strongSelf.photos += _page.photos
            completion(strongSelf.photos)
        }
    }
}
