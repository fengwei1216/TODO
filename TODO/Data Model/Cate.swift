//
//  Cate.swift
//  TODO
//
//  Created by fengwei on 2019/1/26.
//  Copyright © 2019 fengwei. All rights reserved.
//

import Foundation
import RealmSwift
class Cate:Object{
    @objc dynamic var name:String=""
    
    let items = List<Item>()
}
