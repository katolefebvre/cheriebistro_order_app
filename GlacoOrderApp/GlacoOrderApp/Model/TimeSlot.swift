//
//  TimeSlot.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-03-24.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class TimeSlot: NSObject {

    var id: String?
    var name: String?
    
    override init() {}
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}