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
    var categoriesList : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesList = ["Breakfast", "Lunch", "Dinner", "Dessert"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        tableCell.textLabel?.text = categoriesList[indexPath.row]
        tableCell.selectedBackgroundView = cellBackgroundView
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (controllerDelegate?.categories.contains(cell.textLabel!.text!))! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let selectedCellContent = selectedCell?.textLabel?.text
        
        if !(controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.addCategory(category: selectedCellContent!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let selectedCellContent = selectedCell?.textLabel?.text
        if (controllerDelegate?.categories.contains(selectedCellContent!))! {
            controllerDelegate?.removeCategory(category: selectedCellContent!)
        }
        
    }
}
