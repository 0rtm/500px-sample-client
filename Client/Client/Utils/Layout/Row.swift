//
//  Row.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit

class Row {

    fileprivate let maxHeight: CGFloat
    fileprivate let maxWidth: CGFloat
    fileprivate let spacing: CGFloat

    fileprivate var items: [IndexPathWithAspectRatio] = []

    init(maxWidth: CGFloat, maxHeight: CGFloat, itemSpacing: CGFloat) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.spacing = itemSpacing
    }

    func addItem(_ item: IndexPathWithAspectRatio) {
        items.append(item)
    }

    func clearItems() {
        items = []
    }

    func isRowComplete() -> Bool {
        let resultingRowHeight = availableWidth * scaleFactorToFitWidth
        return resultingRowHeight <= availableHeigth
    }

    func layoutCompleteRow() -> RowLayout {

        var layoutItems:[IndexPathWithFrame] = []

        var offset: CGFloat = spacing

        for item in items {

            let itemH =  availableWidth * scaleFactorToFitWidth
            let itemW = itemH * item.aspectRatio

            let frame = CGRect(x: offset, y: 0, width: itemW, height: itemH)
            let layout = IndexPathWithFrame(indexPath: item.indexPath, frame: frame)

            layoutItems.append(layout)

            offset += (itemW + spacing)
        }

        return RowLayout(spacing: spacing, items: layoutItems)
    }

    func layoutIncompleteRow() ->  RowLayout {

        var layoutItems:[IndexPathWithFrame] = []

        var offset: CGFloat = spacing

        for item in items {

            let aspectRatio = item.aspectRatio

            let cH = min(availableHeigth, max(availableHeigth/aspectRatio, availableHeigth*aspectRatio))
            let cW = cH * aspectRatio

            let frame = CGRect(x: offset, y: 0, width: cW, height: cH)
            let layout = IndexPathWithFrame(indexPath: item.indexPath, frame: frame)

            layoutItems.append(layout)

            offset += (cW + spacing)
        }

       return RowLayout(spacing: spacing, items: layoutItems)
    }

    fileprivate func widthTakenBySpacing(forItemsCount count: Int) -> CGFloat {
        let sideSpace = 2 * spacing
        let spaceBetweenCells = spacing * CGFloat (count - 1)
        return sideSpace + spaceBetweenCells
    }

    fileprivate var heightTakenBySpacing: CGFloat {
        return 2 * spacing
    }

    fileprivate var availableWidth: CGFloat {
        let widthTaken =  widthTakenBySpacing(forItemsCount: items.count)
        return maxWidth - widthTaken
    }

    fileprivate var availableHeigth: CGFloat {
        return maxHeight - heightTakenBySpacing
    }

    fileprivate var widthForAllItems: CGFloat {
        return items.map({$0.aspectRatio * availableWidth}).reduce(0, +)
    }

    fileprivate var scaleFactorToFitWidth: CGFloat {
        return availableWidth/widthForAllItems
    }

}
