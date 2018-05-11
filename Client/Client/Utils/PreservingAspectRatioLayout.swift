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

    override func prepare() {
        // 1
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

//        // 2
//        let columnWidth = contentWidth / CGFloat(numberOfColumns)
//        var xOffset = [CGFloat]()
//        for column in 0 ..< numberOfColumns {
//            xOffset.append(CGFloat(column) * columnWidth)
//        }
//        var column = 0
//        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        // 3


        let spacing = delegate.spacing()

        var spaceLeftInRow = contentWidth - spacing

        var currentRowH: CGFloat = 0.0

        var row = Row()
        row.maxH = 150
        row.maxW = contentWidth
        row.spacer = 8.0



        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

//
            let indexPath = IndexPath(item: item, section: 0)

            let aspectRatio = delegate.collectionView(collectionView, aspectRatioForCellAtIndexPath: indexPath)

            row.items.append((indexPath, aspectRatio))

            if row.isRowComplete() {
//
                let layouts = row.layout()
//
                for layout in layouts {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: layout.0)
                    attributes.frame = layout.1
                    attributes.frame.origin.y = currentRowH
                    cache.append(attributes)
                }
                currentRowH += layouts.first!.1.height
                row = Row()
                row.maxH = 150
                row.maxW = contentWidth
                row.spacer = 8.0
                print("complete")


            } else {
                print("no")
            }


//
//
//            let maxH = delegate.maxHeightForRow()
//
//            let cH = min(maxH, max(maxH/aspectRatio, maxH*aspectRatio))
//            let cW = min(contentWidth, maxH*aspectRatio)
//
//            let cellX: CGFloat
//            let cellY: CGFloat
//
//            if (spaceLeftInRow - spacing > cW) {
//                cellX = contentWidth - spaceLeftInRow - spacing
//                spaceLeftInRow -= (cW + spacing)
//
//               //spaceLeftInRow + spacing
//                cellY = currentRowH
//
//            } else {
//                spaceLeftInRow = contentWidth
//                currentRowH += (maxH + spacing)
//
//                cellX = contentWidth - spaceLeftInRow
//                cellY = currentRowH
//            }


//            // 4
//            let photoHeight = CGFloat(100.0)//delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
//            let height = cellPadding * 2 + photoHeight
//            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
//            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
//
//            // 5

//            let frame = CGRect(x: cellX, y: cellY, width: cW, height: cH)
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = frame
//            cache.append(attributes)
//
//            // 6
            contentHeight = max(contentHeight, currentRowH)
//            yOffset[column] = yOffset[column] + height
//
//            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    var currentGrid:[CGFloat] = []

//    func layoutGrid(){
//
//        if ()
//
//    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        // Loop through the cache and look for items in the rect
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
    
}
