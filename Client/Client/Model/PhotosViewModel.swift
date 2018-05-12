//
//  Photos.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit
import Dwifft

class PhotosViewModel: NSObject {

    // Pagination
    private var currentPage = 1
    private let loadingLimit = 10

    private let networking = Networking()

    // Presentation
    fileprivate let collectionView: UICollectionView
    fileprivate let diffCalculator: CollectionViewDiffCalculator<Int, Photo>

    // Photos
    fileprivate var photos: [Photo]

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView,
                                                           initialSectionedValues: PhotosViewModel.sectionedPhotos(photos: []))
        self.photos = []

        super.init()
    }

    var numberOfSections: Int {
        return 1
    }

    func numberOfPhotosInSection(_ section: Int) -> Int {
        return diffCalculator.numberOfObjects(inSection: section)
    }

    func photo(atIndexPath indexPath: IndexPath) -> Photo {
        return diffCalculator.value(atIndexPath: indexPath)
    }

    fileprivate static func sectionedPhotos(photos: [Photo]) -> SectionedValues<Int, Photo> {
        let values:[(Int, [Photo])] = [(0, photos)]
        return SectionedValues(values)
    }


    func loadPhotos() {
        loadPage(completion: {[weak self] (photos: [Photo])  in
            guard let strongSelf = self else { return }
            let sectionedV = PhotosViewModel.sectionedPhotos(photos: photos)
            strongSelf.diffCalculator.sectionedValues = sectionedV
        })
    }

    func loadMorePhotos() {
        loadMore(completion: {[weak self] (photos: [Photo])  in
            guard let strongSelf = self else { return }
            let sectionedV = PhotosViewModel.sectionedPhotos(photos: photos)
            strongSelf.diffCalculator.sectionedValues = sectionedV
        })
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


