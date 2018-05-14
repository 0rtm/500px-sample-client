//
//  PhotoViewerViewController.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    var viewModel: PhotosViewModel!
    var presentable: TablePresentable?
    var dataModel: PhotosDataModel!

    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate let infoCellId = "infoCell"
    fileprivate let spacing: CGFloat = 4.0

    fileprivate var prevIndexPathAtCenter: IndexPath?

    fileprivate var currentIndexPath: IndexPath? {
        let center = view.convert(collectionView.center, to: collectionView)
        return collectionView.indexPathForItem(at: center)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupTableView()
        setupCollectionView()
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        if let indexAtCenter = currentIndexPath {
            prevIndexPathAtCenter = indexAtCenter
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @IBAction func closePressed(_ sender: Any) {
        close()
    }

    fileprivate func setupTitle() {
        title = "Info"
    }

    fileprivate func setupTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }

    fileprivate func setupCollectionView() {
        collectionView.register(PreviewerCollectionViewCell.nib,
                                forCellWithReuseIdentifier: PreviewerCollectionViewCell.reuseIdentifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel = PhotosViewModel(collectionView: collectionView, dataModel: dataModel)

        DispatchQueue.main.async {[weak self] in
            self?.viewModel.refresh()
        }
    }

    fileprivate func close() {
        dataModel.selectedIndex = currentIndexPath
        dismiss(animated: true, completion: nil)
    }

    fileprivate func showInfoAbout(_ photo: Photo){
        presentable = photo
        infoTableView.reloadData()
    }
}

extension PhotoViewerViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presentable?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentable?.sections[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presentable?.sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoCellId, for: indexPath)
        let info = (presentable?.sections[indexPath.section].items[indexPath.row])!
        cell.textLabel?.text = info.0
        cell.detailTextLabel?.text = info.1
        return cell
    }
}

extension PhotoViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotosInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewerCollectionViewCell.reuseIdentifier, for: indexPath) as! PreviewerCollectionViewCell

        let photo = viewModel.photo(atIndexPath: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.red : UIColor.orange
        cell.configureFor(photo: photo)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if viewModel.isLastIndexPath(indexPath) {
            viewModel.loadMorePhotos()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let currentIndex = currentIndexPath else {
            return
        }

        let photo = viewModel.photo(atIndexPath: currentIndex)
        dataModel.selectedIndex = currentIndexPath
        showInfoAbout(photo)
    }
}

extension PhotoViewerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width-spacing, height: collectionView.bounds.height-1)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, spacing/2, 0, spacing/2)
    }

    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {

        guard let oldCenter = prevIndexPathAtCenter else {
            return proposedContentOffset
        }

        let attrs =  collectionView.layoutAttributesForItem(at: oldCenter)

        let newOriginForOldCenter = attrs?.frame.origin
        
        return newOriginForOldCenter ?? proposedContentOffset
    }
}

