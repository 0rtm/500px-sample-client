//
//  RowLayout.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-13.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
import UIKit

struct IndexPathWithFrame {
    let indexPath: IndexPath
    let frame: CGRect
}

struct IndexPathWithAspectRatio {
    let indexPath: IndexPath
    let aspectRatio: CGFloat
}

struct RowLayout {

    let spacing: CGFloat
    let items: [IndexPathWithFrame]

    var rowHeight: CGFloat {

        guard let height = items.first?.frame.height else {
            return 0
        }
        return height + spacing
    }
}
