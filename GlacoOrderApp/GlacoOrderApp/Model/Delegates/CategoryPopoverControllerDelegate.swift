//
//  CategoryPopoverControllerDelegate.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import Foundation

/// A delegate for the CategoryPopoverViewController
public protocol CategoryPopoverControllerDelegate {
    
    func getCategories() -> [Category]
    func addCategory(category : Category)
    func removeCategory(category : Category)
}
