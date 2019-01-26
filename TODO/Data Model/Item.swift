//
//  Item.swift
//  TODO
//
//  Created by fengwei on 2019/1/26.
//  Copyright © 2019 fengwei. All rights reserved.
//

import Foundation
import RealmSwift
class Item:Object{
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool = false;
    @objc dynamic var dataCreated:Date?
    var parentCategory = LinkingObjects(fromType: Cate.self, property: "items")
}
