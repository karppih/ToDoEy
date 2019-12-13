//
//  Category.swift
//  ToDoEy
//
//  Created by Helen Karppi on 12/8/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
