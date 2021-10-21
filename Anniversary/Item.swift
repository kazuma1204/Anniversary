//
//  Item.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/01/31.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var date: String? = nil
    @objc dynamic var title: String? = nil
    @objc dynamic var content: String? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var imageURL:String=""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
