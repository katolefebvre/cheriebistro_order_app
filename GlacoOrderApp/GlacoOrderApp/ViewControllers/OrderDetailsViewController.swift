//
//  OrderDetailsViewController.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-12.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderNumLbl: UILabel!
    @IBOutlet weak var tableNumLbl: UILabel!
    @IBOutlet weak var costNumLbl: UILabel!
    @IBOutlet weak var orderItemsTable: UITableView!
    @IBOutlet weak var saveOrderBtn: GlacoButton!
    
    public var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order?.orderItems = DatabaseAccess.getOrderDetails(orderID: order!.id)
        
        DispatchQueue.main.async {
            self.orderItemsTable.reloadData()
        }
        
        orderNumLbl.text = "Order # \(order?.id ?? 0)"
        tableNumLbl.text = "Table # \(order?.tableId ?? 0)"
        costNumLbl.text = "Total Cost: $\(order?.totalPrice ?? 0.00)"
        
        if order?.status == "Cancelled" {
            saveOrderBtn.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (order?.orderItems!.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrderItemsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "orderItem") as? OrderItemsTableViewCell ?? OrderItemsTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "orderItem")
        cell?.itemNameLbl.text = order!.orderItems![indexPath.row].menuItem.name
        cell?.itemModTf.text = order!.orderItems![indexPath.row].itemModification
        cell?.itemQtyLbl.text = String(order!.orderItems![indexPath.row].quantity)
        cell?.itemQtyStepper.value = Double(order!.orderItems![indexPath.row].quantity)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, bool)  in
            let deleteAlert = UIAlertController(title: "Delete this item?", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.order!.orderItems!.remove(at: indexPath.row)
                self.orderItemsTable.deleteRows(at: [indexPath], with: .fade)
            })
            
            deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func saveOrder(_ sender: Any) {
        for row in 0...orderItemsTable.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: row, section: 0)
            let cell: OrderItemsTableViewCell? = orderItemsTable.cellForRow(at: indexPath) as? OrderItemsTableViewCell
            
            if cell == nil {
                continue // safety net
            } else {
                order!.orderItems![indexPath.row].itemModification = cell?.itemModTf.text ?? ""
                order!.orderItems![indexPath.row].quantity = Int(cell?.itemQtyStepper.value ?? 0)
            }
        }
    }
}
