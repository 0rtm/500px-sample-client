//
//  PreviewerCollectionViewCell.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import UIKit

class PreviewerCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "previewerCell"
    static let nib = UINib(nibName: "PreviewerCollectionViewCell", bundle: nil)

    @IBOutlet fileprivate weak var scrollView: UIScrollView!

    fileprivate var oldBounds: CGRect = CGRect.zero

    fileprivate var imageView: UIImageView = UIImageView() {
        didSet {
            if let image = imageView.image {
                imageView.frame = calculateRect(image: image, size: scrollView.bounds.size)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupScrollView()
        setupImageView()
        setupGesture()
    }

    deinit {
        scrollView.removeObserver(self, forKeyPath: #keyPath(bounds))
    }

    fileprivate func setupScrollView(){
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        scrollView.contentSize = imageView.frame.size
        scrollView.addObserver(self, forKeyPath: #keyPath(bounds), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard keyPath == #keyPath(bounds) else { return }

        guard let image = imageView.image else { return }

        let isWidthChanged = oldBounds.width != scrollView.bounds.width
        let isHeightChanged =  oldBounds.height != scrollView.bounds.height

        if (isWidthChanged || isHeightChanged) {

            oldBounds = scrollView.bounds
            imageView.frame = calculateRect(image: image, size: scrollView.bounds.size)
            scrollView.contentSize = imageView.frame.size
        }
    }

    fileprivate func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }

    fileprivate func setupGesture() {
        let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        double.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(double)
    }

    override func prepareForReuse() {
        imageView.image = nil
    }

    func configureFor(photo: Photo) {
        backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        if let photoURLString = photo.imageURL {
            imageView.af_setImage(withURL: photoURLString)
        }
    }

    func calculateRect(image: UIImage, size: CGSize) -> CGRect {
        return CGRect(origin: CGPoint.zero, size: size)
    }

    @objc fileprivate func doubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: scrollView)

        let zoomSideLength: CGFloat = 40.0

        if scrollView.zoomScale == 1.0 {
            scrollView.zoom(to: CGRect(x: point.x-zoomSideLength/2,
                                       y: point.y-zoomSideLength/2,
                                       width: zoomSideLength,
                                       height: zoomSideLength), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
}

extension PreviewerCollectionViewCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize    = scrollView.bounds.size
        var frameToCenter = imageView.frame

        let widthDiff  = boundsSize.width  - frameToCenter.size.width
        let heightDiff = boundsSize.height - frameToCenter.size.height
        frameToCenter.origin.x = (widthDiff  > 0) ? widthDiff  / 2 : 0
        frameToCenter.origin.y = (heightDiff > 0) ? heightDiff / 2 : 0

        imageView.frame = frameToCenter
    }
}
