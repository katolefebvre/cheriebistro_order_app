//
//  OrderItem.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-12.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

class OrderItem {
    
    var orderId: Int
    var quantity: Int
    var itemModification: String
    var menuItem: MenuItem
    
    init(orderId: Int, quantity: Int, itemModification: String, menuItem: MenuItem) {
        self.orderId = orderId
        self.quantity = quantity
        self.itemModification = itemModification
        self.menuItem = menuItem
    }
}
