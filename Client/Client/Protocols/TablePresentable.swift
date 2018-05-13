//
//  TablePresentable.swift
//  Client
//
//  Created by Artem Tselikov on 2018-05-12.
//  Copyright © 2018 Artem Tselikov. All rights reserved.
//

import Foundation

typealias TableItem = (String, String)

struct Section {
    let title: String
    let items: [TableItem]
}

protocol TablePresentable {
    var sections: [Section] { get }
}
