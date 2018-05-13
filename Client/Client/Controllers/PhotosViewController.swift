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

    fileprivate var viewModel: PhotosViewModel!
    fileprivate var dataModel: PhotosDataModel!
    fileprivate var selectedIndex: IndexPath?

    fileprivate let showPreviewSegueId = "showPreview"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = "Popular"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {[weak self] in
            self?.viewModel.refresh()
            self?.dataModel.selectedIndex = nil
        }
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
            previewVC.viewModel = viewModel
            previewVC.dataModel = dataModel
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

        dataModel = PhotosDataModel()
        viewModel = PhotosViewModel(collectionView: collectionView, dataModel: dataModel)
        viewModel.loadPhotos()
    }
}


extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotosInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

        let photo = viewModel.photo(atIndexPath: indexPath)
        cell.configureFor(photo: photo)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if (viewModel.isLastIndexPath(indexPath)) {
             viewModel.loadMorePhotos()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        dataModel.selectedIndex = selectedIndex
        performSegue(withIdentifier: showPreviewSegueId, sender: self)
    }
}


extension PhotosViewController: PreservingAspectRatioLayoutDelegate {

    func maxHeightForRow() -> CGFloat {
        return 160.0
    }

    func collectionView(_ collectionView: UICollectionView,
                   aspectRatioForCellAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let photo = viewModel.photo(atIndexPath: indexPath)
        return CGFloat(photo.aspectRatio)
    }

    func spacing() -> CGFloat {
        return 4.0
    }
}
