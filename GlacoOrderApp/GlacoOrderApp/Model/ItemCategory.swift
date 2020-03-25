//
//  ItemCategory.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class ItemCategory {
    var id : Int
    var category : String
    
    init(id : Int, category: String) {
        self.id = id
        self.category = category
    }
}
