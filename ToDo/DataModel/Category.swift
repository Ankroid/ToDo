//
//  Category.swift
//  ToDo
//
//  Created by Ankur Badola on 5/9/18.
//  Copyright © 2018 Ankur Badola. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
