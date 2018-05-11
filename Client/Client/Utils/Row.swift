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

        //let nexMaxW = maxW/CGFloat(items.count)
        //var spaceLeft = nexMaxW

        layoutItems = []

        let totlalW = items.map({$0.1 * maxW}).reduce(0, +)
        let scaleFactorToFitW = maxW/totlalW

        var spaceLeft = maxW
        var offset: CGFloat = 0

        for (index,item) in items.enumerated() {

        //let itemW = //maxW/scaleFactorToFitW
        let itemH =  maxW * scaleFactorToFitW//itemW/item.1 // aspect ratio
        let itemW = itemH*item.1
//            let itemW = nexMaxW///item.1
//

             layoutItems.append((item.0, CGRect(x: offset, y: 0, width: itemW, height: itemH)))
offset += itemW
//            if (offset + itemW < maxW) {
//                spaceLeft += itemW
//            }
//
//            let itemH = itemW/item.1
//


            if (itemH > maxH) {
                return false
            }

        }
        //layoutItems = []
        return true


//
//        if items.count == 1 {
//            return avaliableSpace/items.first!.1 < maxH
//        }
//
//        if items.count == 2 {
//
//            let h1 = avaliableSpace/items.first!.1
//            let h2 = avaliableSpace/items[1].1
//
//            return min(h1, h2)
//        }

        return true
    }

    func layout() -> [(IndexPath, CGRect)] {
////
//        let nexMaxW = maxW///CGFloat(items.count)
//        var spaceLeft = nexMaxW
//
//        for item in items {
//
//            let itemW = item.1*nexMaxW
//
//            if (spaceLeft - itemW > 0) {
//                spaceLeft -= itemW
//            }
//
//            let itemH = itemW/item.1
//
//            layoutItems.append((item.0,CGRect(x: spaceLeft, y: 0, width: itemW, height: itemH)))
//        }
        return layoutItems
        //layoutItems = []
    }

    func minH() -> CGFloat {

        var minH = hForItem(item: items.first!)
        for item in items {
            if hForItem(item: item) < minH {
                minH = hForItem(item: item)
            }
        }

        return minH
    }

    func hForItem(item: Item) ->CGFloat {
        return maxW/item.1
    }


}
