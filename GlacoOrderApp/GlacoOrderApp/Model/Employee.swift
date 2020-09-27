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
    var role : Role
    
    init(id : String, name : String, role : Role) {
        self.id = id
        self.name = name
        self.role = role
    }
    
    init(id : String, name : String, roleID : String, roleName : String) {
        self.id = id
        self.name = name
        self.role = Role(id: roleID, name: roleName)
    }
    
}
