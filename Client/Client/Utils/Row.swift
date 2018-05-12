//
//  Row.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-10.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit

typealias Item = (IndexPath, CGFloat)
typealias lItem = (IndexPath, CGRect)

class Row {

    init() {
    }

    var maxH: CGFloat = 0.0
    var maxW: CGFloat = 0.0
    var spacer: CGFloat = 0.0

    var items: [Item] = []
    var layoutItems: [lItem] = []

    func isRowComplete() -> Bool {

        layoutItems = []

        let spacing =  2 * spacer + (spacer * CGFloat(items.count-1))
        let availW = maxW - spacing

        let totlalW = items.map({$0.1 * availW}).reduce(0, +)
        let scaleFactorToFitW = availW/totlalW

        var offset: CGFloat = spacer

        for item in items {

        let itemH =  availW * scaleFactorToFitW//itemW/item.1 // aspect ratio
        let itemW = itemH*item.1

            layoutItems.append((item.0, CGRect(x: offset, y: 0, width: itemW, height: itemH)))
            offset += (itemW + spacer)

            if (itemH > maxH - (2 * spacer)) {
                return false
            }

        }
        return true
    }

    func layout() -> [(IndexPath, CGRect)] {
        return layoutItems
    }

    func layoutIncompleteRow() ->  [(IndexPath, CGRect)] {
        layoutItems = []

        let spacing =  2 * spacer + (spacer * CGFloat(items.count-1))
        let availW = maxW - spacing
        let availH = maxH - (2 * spacer)


//        let totlalW = items.map({$0.1 * availW}).reduce(0, +)
//        let scaleFactorToFitW = availW/totlalW
//
//        let maxHwithScaledW = items.map({availW * $0.1}).max()!
//
//
//
//        let scaleFactorToFitH = availH/(maxHwithScaledW)
//
//        let sclateToFitXandY = max(scaleFactorToFitW, scaleFactorToFitH)
//
       var offset: CGFloat = spacer

        for item in items {

            let aspectRatio = item.1

            let cH = min(availH, max(availH/aspectRatio, availH*aspectRatio))
            let cW = cH * aspectRatio
            layoutItems.append((item.0, CGRect(x: offset, y: 0, width: cW, height: cH)))
            offset += (cW + spacer)
        }

        return layoutItems
    }

    func rowH() -> CGFloat {
        return (layoutItems.first?.1.height)!+spacer
    }

    func hForItem(item: Item) ->CGFloat {
        return maxW/item.1
    }


}
