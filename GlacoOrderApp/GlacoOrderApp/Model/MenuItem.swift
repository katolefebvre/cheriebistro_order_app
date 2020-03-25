//
//  MenuItem.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class MenuItem {
    
    let itemId : Int
    let name : String
    let price : Float
    let availability : Bool
    let category : ItemCategory
    
    init(itemId: Int, name: String, price: Float, availability: Bool, category: ItemCategory) {
        self.itemId = itemId
        self.name = name
        self.price = price
        self.availability = availability
        self.category = category
    }
    
    
}
