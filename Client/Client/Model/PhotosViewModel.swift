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

    // Presentation
    fileprivate let collectionView: UICollectionView
    fileprivate let diffCalculator: CollectionViewDiffCalculator<Int, Photo>

    fileprivate let dataModel: PhotosDataModel

    public init(collectionView: UICollectionView, dataModel: PhotosDataModel) {
        self.collectionView = collectionView
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView,
                                                           initialSectionedValues: PhotosViewModel.sectionedPhotos(photos: []))
        self.dataModel = dataModel
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

    func loadPhotos() {
        dataModel.loadPhotos {[weak self] (photos) in
            self?.updateDiffValues(photos)
            self?.displaySelectedIndex()
        }
    }

    func loadMorePhotos() {
        dataModel.loadMorePhotos {[weak self] (photos) in
            self?.updateDiffValues(photos)
            self?.displaySelectedIndex()
        }
    }

    func refresh() {
        dataModel.storedPhotos {[weak self] (photos) in
            self?.updateDiffValues(photos)
            self?.displaySelectedIndex()
        }
    }

    func isLastIndexPath(_ indexPath: IndexPath) -> Bool {

        let isLastSection = indexPath.section == numberOfSections - 1
        let isLastRow = indexPath.row == numberOfPhotosInSection(indexPath.section) - 1

        return isLastSection && isLastRow
    }

    fileprivate static func sectionedPhotos(photos: [Photo]) -> SectionedValues<Int, Photo> {
        let values: [(Int, [Photo])] = [(0, photos)]
        return SectionedValues(values)
    }

    fileprivate func updateDiffValues(_ photos: ([Photo])) {
        let sectionedV = PhotosViewModel.sectionedPhotos(photos: photos)
        diffCalculator.sectionedValues = sectionedV
    }

    fileprivate func displaySelectedIndex() {
        guard let _selectedIndex = dataModel.selectedIndex else {
            return
        }

        let direction: UICollectionViewScrollPosition

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            direction = layout.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        } else {
            direction = .centeredVertically
        }
    
        collectionView.scrollToItem(at:_selectedIndex, at: direction, animated: false)
    }
}
