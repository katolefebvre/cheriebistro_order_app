//
//  TableOrder.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

class Order {
    
    var id: Int
    var tableId: Int
    var totalPrice: Float
    var status: String
    var orderItems : [OrderItem]?
    
    init(id: Int, tableId: Int, totalPrice: Float, status: String) {
        self.id = id
        self.tableId = tableId
        self.totalPrice = totalPrice
        self.status = status
    }
    
    func updateTotalWithTax(){
        self.totalPrice = 0
        for item in self.orderItems! {
            self.totalPrice += item.menuItem.price * 1.13 * Float(item.quantity)
        }
    }
}
