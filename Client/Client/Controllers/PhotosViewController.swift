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
        photosModel.loadPage(completion: {[weak self] in
            self?.collectionView.reloadData()
        })
    }
}


extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModel.photos.count
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = UIColor.orange

        let photo = photosModel.photos[indexPath.row]

        if let photoURLString = photo.images.first?.httpsURL {
              cell.imageView.af_setImage(withURL: photoURLString)
        }

        return cell
    }

}
