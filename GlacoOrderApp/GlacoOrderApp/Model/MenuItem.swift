//
//  MenuItem.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class MenuItem {
    
    // NOTE: Removing categories for now until I can get it to work
    
    let id : Int
    let name : String
    let description : String
    let price : Float
    let timeslot : TimeSlot
//    let categories : [Category]
    
    init(id: Int, name: String, description: String, price: Float, timeslot: TimeSlot) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.timeslot = timeslot
//        self.categories = categories
    }
    
    
}
