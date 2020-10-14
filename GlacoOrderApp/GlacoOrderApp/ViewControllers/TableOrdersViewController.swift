//
//  TableOrdersViewController.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class TableOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewPendingBtn: UIButton!
    @IBOutlet weak var viewConfirmedBtn: UIButton!
    
    var orders: [Order] = []
    var visibleOrders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orders = DatabaseAccess.getOrders()
        
        visibleOrders = orders
        
        if orders.count == 0 {
            let emptyOrdersAlertController = UIAlertController(title: "No Orders Available", message: "No orders are available to manage at this time.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { alertAction in
                self.navigationController?.popViewController(animated: true)
            }
            emptyOrdersAlertController.addAction(cancelAction)
            self.present(emptyOrdersAlertController, animated: true)
        }
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = false
    }
    
    @IBAction private func viewAllOrders() {
        visibleOrders = []
        visibleOrders = orders
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = false
        viewPendingBtn.isEnabled = true
        viewConfirmedBtn.isEnabled = true
    }
    
    @IBAction private func viewPendingOrders() {
        visibleOrders = []
        
        for o in orders {
            if o.status == "Pending" {
                visibleOrders.append(o)
            }
         }
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = true
        viewPendingBtn.isEnabled = false
        viewConfirmedBtn.isEnabled = true
    }
    
    @IBAction private func viewConfirmedOrders() {
        visibleOrders = []
        
        for o in orders {
            if o.status == "Confirmed" {
                visibleOrders.append(o)
            }
        }
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = true
        viewPendingBtn.isEnabled = true
        viewConfirmedBtn.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : OrdersTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "order") as? OrdersTableViewCell ?? OrdersTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "order")
        tableCell?.orderName.text = "Order \(visibleOrders[indexPath.row].id) - Table \(visibleOrders[indexPath.row].tableId)"
        tableCell?.orderStatus.text = visibleOrders[indexPath.row].status
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions : [UIContextualAction] = []
        
        if self.visibleOrders[indexPath.row].status != "Confirmed" {
            let confirm = UIContextualAction(style: .normal, title: "Confirm") { (action, view, bool) in
                let confirmOrderAlertController = UIAlertController(title: "Confirm Order", message: "Are you sure you want to confirm this order?", preferredStyle: .alert)
                
                confirmOrderAlertController.addAction(UIAlertAction(title: "Confirm", style : .default, handler : { [self] (action : UIAlertAction!) in
                    let response : [String : String] = DatabaseAccess.changeOrderStatus(orderID: visibleOrders[indexPath.row].id, status: "Confirmed")
                        if response["error"] == "false" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Confirmation Successful", message: "Order confirmed successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                self.visibleOrders[indexPath.row].status = "Confirmed"
                                self.ordersTable.reloadData()
                            }
                        } else {
                            print("error")
                        }
                    }
                ))
                
                confirmOrderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(confirmOrderAlertController, animated: true)
            }
            actions.append(confirm)
        }
        
        if self.visibleOrders[indexPath.row].status != "Cancelled" {
            let cancel = UIContextualAction(style: .destructive, title: "Cancel") { (action, view, bool) in
                let cancelOrderAlertController = UIAlertController(title: "Cancel Order", message: "Are you sure you want to cancel this order?", preferredStyle: .alert)
                
                cancelOrderAlertController.addAction(UIAlertAction(title: "Confirm", style : .destructive, handler : { [self] (action : UIAlertAction!) in
                    let response : [String : String] = DatabaseAccess.changeOrderStatus(orderID: visibleOrders[indexPath.row].id, status: "Cancelled")
                        if response["error"] == "false" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Cancellation Successful", message: "Order cancelled successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                self.visibleOrders[indexPath.row].status = "Cancelled"
                                self.ordersTable.reloadData()
                            }
                        } else {
                            print("error")
                        }
                    }
                ))
                
                cancelOrderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(cancelOrderAlertController, animated: true)
            }
            actions.append(cancel)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let orderDetailsViewController = segue.destination as? OrderDetailsViewController,
              let index = ordersTable.indexPathForSelectedRow?.row
        else {
            return
        }
        orderDetailsViewController.order = visibleOrders[index]
    }
}
