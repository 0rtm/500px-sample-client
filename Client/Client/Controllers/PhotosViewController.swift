//
//  PhotosViewController.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate var photosModel: PhotosViewModel!
    fileprivate var selectedPhoto: Photo?

    fileprivate let showPreviewSegueId = "showPreview"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = "Popular"
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showPreviewSegueId {
            guard let navVC = (segue.destination) as? UINavigationController,
                let previewVC = navVC.viewControllers.first as? PhotoViewerViewController else {
                return
            }
            previewVC.photosModel = photosModel
            previewVC.selectedPhoto = selectedPhoto
        }
    }

    fileprivate func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.nib,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? PreservingAspectRatioLayout {
            layout.delegate = self
        }

        photosModel = PhotosViewModel(collectionView: collectionView)
        photosModel.loadPhotos()
    }

    fileprivate func requestMorePhotos() {
        photosModel.loadMorePhotos()
    }
}


extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModel.numberOfPhotosInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

        let photo = photosModel.photo(atIndexPath: indexPath)
        cell.configureFor(photo: photo)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let isLastSection = indexPath.section == photosModel.numberOfSections - 1
        let isLastRow = indexPath.row == photosModel.numberOfPhotosInSection(indexPath.section) - 1

        let isLastCell = isLastSection && isLastRow

        if isLastCell {
            requestMorePhotos()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = photosModel.photo(atIndexPath: indexPath)
        performSegue(withIdentifier: showPreviewSegueId, sender: self)
    }
}


extension PhotosViewController: PreservingAspectRatioLayoutDelegate {

    func maxHeightForRow() -> CGFloat {
        return 160.0
    }

    func collectionView(_ collectionView: UICollectionView,
                   aspectRatioForCellAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let photo = photosModel.photo(atIndexPath: indexPath)
        return CGFloat(photo.aspectRatio)
    }

    func spacing() -> CGFloat {
        return 4.0
    }
}
