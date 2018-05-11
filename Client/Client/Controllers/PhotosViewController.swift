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

    fileprivate let rowH = 100.0

    var photosModel:PhotosViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        photosModel = PhotosViewModel()
        setupCollectionView()
    }

    fileprivate func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)//(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? PreservingAspectRatioLayout {
            layout.delegate = self
        }

        photosModel.loadPage(completion: {[weak self] in
            self?.collectionView.reloadData()
        })
    }

    func colorForCell(path: IndexPath) -> UIColor {
        return path.row % 2 == 0 ? UIColor.red : UIColor.cyan
    }

}


extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return photosModel.aspects.count//
        return photosModel.photos.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

        cell.backgroundColor = colorForCell(path: indexPath)
     let photo = photosModel.photos[indexPath.row]
//
        if let photoURLString = photo.images.first?.httpsURL {
              cell.imageView.af_setImage(withURL: photoURLString)
        }

        return cell
    }
}

extension PhotosViewController: PreservingAspectRatioLayoutDelegate {
    func maxHeightForRow() -> CGFloat {


        return CGFloat(rowH)
    }

    func collectionView(_ collectionView: UICollectionView,
                   aspectRatioForCellAtIndexPath indexPath:IndexPath) -> CGFloat {

       // return photosModel.aspects[indexPath.row]

        let photo = photosModel.photos[indexPath.row]
        return CGFloat(photo.aspectRatio)
    }

    func spacing() -> CGFloat {
        return 4.0
    }
}

//extension PhotosViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let photo = photosModel.photos[indexPath.row]
//
//        let asspectedW = rowH * photo.aspectRatio
//
//        return CGSize(width: asspectedW, height: rowH)
//    }
//}
