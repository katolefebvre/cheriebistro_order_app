//
//  CategoryPopoverControllerDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

public protocol CategoryPopoverControllerDelegate {
    
    func getCategories() -> [ItemCategory]
    func addCategory(category : ItemCategory)
    func removeCategory(category : ItemCategory)
}
