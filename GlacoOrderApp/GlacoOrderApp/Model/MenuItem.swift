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
    let categoery : ItemCategory
    
    init(itemId: Int, name: String, price: Float, availability: Bool, categoery: ItemCategory) {
        self.itemId = itemId
        self.name = name
        self.price = price
        self.availability = availability
        self.categoery = categoery
    }
    
    
}
