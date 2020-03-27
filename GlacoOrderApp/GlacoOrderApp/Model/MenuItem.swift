//
//  MenuItem.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-10.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class MenuItem {
    
    /// The ID of the MenuItem
    let id : Int?
    
    /// The Name of the MenuItem
    let name : String
    
    /// The Description of the MenuItem
    let description : String
    
    /// The Price of the MenuItem
    let price : Float
    
    /// The TimeSlot of the MenuItem
    let timeslot : TimeSlot
    
    /// The Categories of the MenuItem
    let categories : [Category]
    
    init(id: Int?, name: String, description: String, price: Float, timeslot: TimeSlot, categories : [Category]) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.timeslot = timeslot
        self.categories = categories
    }
    
    
}
