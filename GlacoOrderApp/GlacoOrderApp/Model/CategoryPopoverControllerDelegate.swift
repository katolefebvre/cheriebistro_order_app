//
//  CategoryPopoverControllerDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public protocol CategoryPopoverControllerDelegate {
    var categories : [String] { get set }
    
    func addCategory(category : String)
    func removeCategory(category : String)
}
