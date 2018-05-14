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

        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

        var currentRowH: CGFloat = 0.0

        let row = Row(maxWidth: contentWidth, maxHeight: maxRowHeight, itemSpacing: spacing)

        for section in 0..<collectionView.numberOfSections {

            for item in 0 ..< collectionView.numberOfItems(inSection: section) {

                let indexPath = IndexPath(item: item, section: section)
                let aspectRatio = delegate.collectionView(collectionView, aspectRatioForCellAtIndexPath: indexPath)

                row.addItem(IndexPathWithAspectRatio(indexPath: indexPath, aspectRatio: aspectRatio))

                if row.isRowComplete() {

                    let layouts = row.layoutCompleteRow()

                    cacheLayouts(layouts, currentRowH)

                    currentRowH += layouts.rowHeight
                    row.clearItems()

                } else {

                    let isLastItem = item == collectionView.numberOfItems(inSection: 0) - 1

                    if  isLastItem {

                        let layouts = row.layoutIncompleteRow()

                        cacheLayouts(layouts, currentRowH)

                        currentRowH += layouts.rowHeight
                    }
                }
            }

            contentHeight = max(contentHeight, currentRowH)
        }
    }

    fileprivate func cacheLayouts(_ layouts: RowLayout, _ currentRowH: CGFloat) {
        for layout in layouts.items {
            cacheAttributes(layout, currentRowH)
        }
    }

    fileprivate func cacheAttributes(_ layout: IndexPathWithFrame, _ currentRowH: CGFloat) {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: layout.indexPath)
        attributes.frame = layout.frame
        attributes.frame.origin.y = currentRowH
        cache.append(attributes)
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
