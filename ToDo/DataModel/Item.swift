//
//  Item.swift
//  ToDo
//
//  Created by Ankur Badola on 5/2/18.
//  Copyright © 2018 Ankur Badola. All rights reserved.
//

import Foundation

//class Item: Encodable, Decodable {
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
