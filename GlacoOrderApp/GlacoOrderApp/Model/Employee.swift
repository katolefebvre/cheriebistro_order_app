//
//  Employee.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-04-07.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public class Employee {
    
    var id : String
    var name : String
    var roleID : String
    
    init(id : String, name : String, roleID : String) {
        self.id = id
        self.name = name
        self.roleID = roleID
    }
    
}
