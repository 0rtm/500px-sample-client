//
//  PhotoCollectionViewCell.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "photoCell"
    static let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        imageView.af_cancelImageRequest()
        imageView.image = nil
    }

    func configureFor(photo: Photo) {
        backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        if let photoURLString = photo.imageURL {
            imageView.af_setImage(withURL: photoURLString)
        }
    }
}
