//
//  Items.swift
//  ToDoEy
//
//  Created by Helen Karppi on 12/8/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String=""
    @objc dynamic var done: Bool=false
    @objc dynamic var createDate: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
