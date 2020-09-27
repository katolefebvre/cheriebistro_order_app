//
//  RolePopoverControlDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-09-27.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

protocol RolePopoverControllerDelegate {
    
    func getRole() -> Role?
    func setEditRole(role : Role)
    
}
