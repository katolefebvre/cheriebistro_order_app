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
    
    let currencyFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "$"
        
        order!.orderItems = DatabaseAccess.getOrderDetails(orderID: order!.id)
        
        DispatchQueue.main.async {
            self.orderItemsTable.reloadData()
        }
        
        orderNumLbl.text = "Order # \(order!.id)"
        tableNumLbl.text = "Table # \(order!.tableId)"
        costNumLbl.text = "Total Cost: \(currencyFormatter.string(from: NSNumber(value: order!.totalPrice)) ?? "0.00")"
        
        if order?.status != "Pending" && order?.status != "Confirmed" {
            saveOrderBtn.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (order?.orderItems!.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrderItemsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "orderItem") as? OrderItemsTableViewCell ?? OrderItemsTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "orderItem")
        cell?.orderItem = order!.orderItems![indexPath.row]
        cell?.itemNameLbl.text = order!.orderItems![indexPath.row].menuItem.name
        cell?.itemModTf.text = order!.orderItems![indexPath.row].itemModification
        cell?.itemQtyLbl.text = String(order!.orderItems![indexPath.row].quantity)
        cell?.itemQtyStepper.value = Double(order!.orderItems![indexPath.row].quantity)
        
        if ((order!.status == "Pending" || order!.status == "Confirmed") && order!.orderItems!.count > 1) {
            cell?.accessoryType = .disclosureIndicator
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActions = UISwipeActionsConfiguration(actions: [])
        if (order!.status != "Cancelled" && order!.orderItems!.count > 1) {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, bool)  in
                let deleteAlert = UIAlertController(title: "Delete this item?", message: "Are you sure you want to delete this item? This cannot be undone.", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                    if DatabaseAccess.editOrderItem(orderItem: self.order!.orderItems![indexPath.row], delete: true) == 1 {
                        self.order!.orderItems!.remove(at: indexPath.row)
                        self.orderItemsTable.deleteRows(at: [indexPath], with: .fade)
                        
                        self.order!.updateTotalWithTax()
                        self.costNumLbl.text = "Total Price: \(self.currencyFormatter.string(from: NSNumber(value: self.order!.totalPrice)) ?? "0.00")"
                    } else {
                        let errorAlert = UIAlertController(title: "ERROR", message: "An error occurred, this order item was not properly deleted.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                })
                
                deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(deleteAlert, animated: true, completion: nil)
            }

            swipeActions = UISwipeActionsConfiguration(actions: [delete])
        }
        return swipeActions
    }
    
    @IBAction func saveOrder(_ sender: Any) {
        let saveAlert = UIAlertController(title: "Save this order?", message: "Are you sure you want to save your changes? This cannot be undone.", preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.order!.updateTotalWithTax()
            
            if DatabaseAccess.editOrder(order: self.order!) == 1 {
                for row in 0...self.orderItemsTable.numberOfRows(inSection: 0) {
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell: OrderItemsTableViewCell? = self.orderItemsTable.cellForRow(at: indexPath) as? OrderItemsTableViewCell
                    
                    if cell == nil {
                        continue // safety net
                    } else {
                        self.order!.orderItems![indexPath.row].itemModification = cell?.itemModTf.text ?? ""
                        self.order!.orderItems![indexPath.row].quantity = Int(cell?.itemQtyStepper.value ?? 0)
                        
                        _ = DatabaseAccess.editOrderItem(orderItem: self.order!.orderItems![indexPath.row], delete: false)
                    }
                }
                
                let successAlert = UIAlertController(title: "Success", message: "Order # \(self.order!.id) was successfully saved.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(successAlert, animated: true, completion: nil)
                
                self.costNumLbl.text = "Total Price: \(self.currencyFormatter.string(from: NSNumber(value: self.order!.totalPrice)) ?? "0.00")"
            } else {
                let errorAlert = UIAlertController(title: "ERROR", message: "An error occurred, this order was not properly saved.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true, completion: nil)
            }
        })
        saveAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(saveAlert, animated: true, completion: nil)
    }
}
