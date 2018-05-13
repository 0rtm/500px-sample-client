//
//  PreservingAspectRatioLayout.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit


protocol PreservingAspectRatioLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView,
                        aspectRatioForCellAtIndexPath indexPath:IndexPath) -> CGFloat

    func maxHeightForRow() -> CGFloat

    func spacing() -> CGFloat
}

class PreservingAspectRatioLayout: UICollectionViewLayout {

    weak var delegate: PreservingAspectRatioLayoutDelegate!

    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6

    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat = 0

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    fileprivate var spacing: CGFloat {
        return delegate.spacing()
    }

    fileprivate var maxRowHeight: CGFloat {
        return delegate.maxHeightForRow()
    }

    override func prepare() {
        // 1
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

        var currentRowH: CGFloat = 0.0

        var row = Row()
        row.maxH = maxRowHeight
        row.maxW = contentWidth
        row.spacer = spacing

        for section in 0..<collectionView.numberOfSections {

            for item in 0 ..< collectionView.numberOfItems(inSection: section) {

                let indexPath = IndexPath(item: item, section: 0)

                let aspectRatio = delegate.collectionView(collectionView, aspectRatioForCellAtIndexPath: indexPath)

                row.items.append((indexPath, aspectRatio))

                if row.isRowComplete() {
                    let layouts = row.layout()
                    for layout in layouts {
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: layout.0)
                        attributes.frame = layout.1
                        attributes.frame.origin.y = currentRowH
                        cache.append(attributes)
                    }

                    currentRowH += row.rowH()
                    row = Row()
                    row.maxH = maxRowHeight
                    row.maxW = contentWidth
                    row.spacer = spacing

                } else {

                    if item == collectionView.numberOfItems(inSection: 0)-1 {

                        let layouts = row.layoutIncompleteRow()
                        //
                        for layout in layouts {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: layout.0)
                            attributes.frame = layout.1
                            attributes.frame.origin.y = currentRowH
                            cache.append(attributes)
                        }
                        currentRowH += layouts.first!.1.height + spacing
                    }
                }
            }

            contentHeight = max(contentHeight, currentRowH)
        }
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func invalidateLayout() {
        cache = []
        contentHeight = 0
    }
}
