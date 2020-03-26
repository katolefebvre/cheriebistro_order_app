//
//  Category.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class Category {
    
    /// The ID of the category.
    var id : Int
    
    /// The name of the category.
    var name : String
    
    init(id : Int, name: String) {
        self.id = id
        self.name = name
    }
}
