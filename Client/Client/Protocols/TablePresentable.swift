//
//  TablePresentable.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation
protocol TablePresentable {
    typealias TableItem = (String, String)
    func items() -> [TableItem]
}
