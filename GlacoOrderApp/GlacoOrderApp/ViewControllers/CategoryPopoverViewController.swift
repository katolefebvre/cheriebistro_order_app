//
//  CategoryPopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class CategoryPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var controllerDelegate : CategoryPopoverControllerDelegate?
    var categoryNames : [String] = []
    var categoryIds : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNames = ["Breakfast", "Lunch", "Dinner", "Dessert"]
        categoryIds = [1, 2, 3, 4]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "category") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "category")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 25)
        tableCell?.textLabel?.text = categoryNames[indexPath.row]
        tableCell?.databaseId = categoryIds[indexPath.row]
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let foundCell : DatabaseIdTableViewCell = cell as! DatabaseIdTableViewCell
        
        if (controllerDelegate?.categories.contains(foundCell.databaseId!))! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if !(controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.addCategory(categoryId: selectedCellContent!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! DatabaseIdTableViewCell
        let selectedCellContent = selectedCell.databaseId
        
        if (controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.removeCategory(categoryId: selectedCellContent!)
        }
        
    }
}
