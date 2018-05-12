//
//  PhotoViewerViewController.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    var photosModel: PhotosViewModel!
    var selectedPhoto: Photo! {
        didSet {
            presentable = selectedPhoto
        }
    }
    var presentable: TablePresentable?

    @IBOutlet weak var infoTableView: UITableView!

    fileprivate let infoCellId = "infoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        infoTableView.reloadData()
    }

    @IBAction func closePressed(_ sender: Any) {
        close()
    }

    fileprivate func setupTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }

    fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }

}

extension PhotoViewerViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentable?.items().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoCellId, for: indexPath)
        let info = presentable?.items()[indexPath.row]
        cell.textLabel?.text = info?.0
        cell.detailTextLabel?.text = info?.1
        return cell
    }



}
