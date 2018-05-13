//
//  PhotosDataModel.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

protocol DataProvider {

}

class PhotosDataModel {

    private var currentPage = 1
    private let loadingLimit = 10

    private let networking = Networking()

    var selectedIndex: IndexPath?

    fileprivate var photos: [Photo] = []

    func loadPhotos(completion: @escaping ([Photo])->()) {
        loadPage(completion: {(photos: [Photo])  in
            completion(photos)
        })
    }

    func loadMorePhotos(completion: @escaping ([Photo])->()) {
        loadMore(completion: {(photos: [Photo])  in
            completion(photos)
        })
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

        networking.getPage(pageNumber: pageNumber){[weak self] (error, page) in

            guard error == nil else {
                print(error.debugDescription)
                fatalError()
            }

            guard let _page = page, let strongSelf = self else {return}

            self?.photos += _page.photos
            completion(strongSelf.photos)
        }
    }
}
