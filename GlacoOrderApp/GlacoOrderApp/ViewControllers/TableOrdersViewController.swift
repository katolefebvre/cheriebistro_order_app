//
//  TableOrdersViewController.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-11.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class TableOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderStatusPopoverControllerDelegate {
    
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewStatusBtn: UIButton!
    @IBOutlet weak var viewMineBtn: GlacoButton!
    
    var orders: [Order] = []
    var visibleOrders: [Order] = []
    
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    @IBAction func displayStatusPopover(_ sender : UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderStatusPopoverViewController") as! OrderStatusPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.controllerDelegate = self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = sender
        present(vc, animated: true, completion:nil)
    }
    
    @IBAction private func viewAllOrders() {
        visibleOrders = []
        visibleOrders = orders
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = false
        viewMineBtn.isEnabled = true
    }
    
    private func viewStatusOrders() {
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
        viewMineBtn.isEnabled = true
    }
    
    @IBAction private func viewMyOrders() {
        visibleOrders = []
        
        for o in orders {
            for table in mainDelegate.loggedEmployee!.tables {
                if o.tableId == Int(table) {
                    visibleOrders.append(o)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = true
        viewMineBtn.isEnabled = false
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
        
        let inprogress = UIContextualAction(style: .normal, title: "In Progress") { (action, view, bool) in
            let progressOrderAlertController = UIAlertController(title: "Confirm Order", message: "Are you sure you want to start progression on this order?", preferredStyle: .alert)
            
            progressOrderAlertController.addAction(UIAlertAction(title: "Yes", style : .default, handler : { [self] (action : UIAlertAction!) in
                let response : [String : String] = DatabaseAccess.changeOrderStatus(orderID: visibleOrders[indexPath.row].id, status: "In Progress")
                    if response["error"] == "false" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Order Status Changed", message: "Order status was changed successfully.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.visibleOrders[indexPath.row].status = "In Progress"
                            self.ordersTable.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            ))
            
            progressOrderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(progressOrderAlertController, animated: true)
        }
        
        let served = UIContextualAction(style: .normal, title: "Served") { (action, view, bool) in
            let servedOrderAlertController = UIAlertController(title: "Order Served", message: "This order has been served.", preferredStyle: .alert)
            
            servedOrderAlertController.addAction(UIAlertAction(title: "OK", style : .default, handler : { [self] (action : UIAlertAction!) in
                let response : [String : String] = DatabaseAccess.changeOrderStatus(orderID: visibleOrders[indexPath.row].id, status: "Served")
                    if response["error"] == "false" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Order Status Changed", message: "Order status was changed successfully.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.visibleOrders[indexPath.row].status = "Served"
                            self.ordersTable.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            ))
            
            servedOrderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(servedOrderAlertController, animated: true)
        }
        
        let paid = UIContextualAction(style: .normal, title: "Paid") { (action, view, bool) in
            let paidOrderAlertController = UIAlertController(title: "Order Paid", message: "This order has been paid for.", preferredStyle: .alert)
            
            paidOrderAlertController.addAction(UIAlertAction(title: "Yes", style : .default, handler : { [self] (action : UIAlertAction!) in
                let response : [String : String] = DatabaseAccess.changeOrderStatus(orderID: visibleOrders[indexPath.row].id, status: "Paid")
                    if response["error"] == "false" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Order Status Changed", message: "Order status was changed successfully.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.visibleOrders[indexPath.row].status = "Paid"
                            self.ordersTable.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            ))
            
            paidOrderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(paidOrderAlertController, animated: true)
        }
        
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
        
        switch self.visibleOrders[indexPath.row].status {
            case "Pending":
                actions.append(confirm)
            case "Confirmed":
                actions.append(inprogress)
                actions.append(cancel)
            case "In Progress":
                actions.append(served)
                actions.append(cancel)
            case "Served":
                actions.append(paid)
                actions.append(cancel)
            case "Paid":
                break
            default:
                break
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
    
    func setOrderStatus(status: String) {
        visibleOrders = []
        
        for o in orders {
            if o.status == status {
                visibleOrders.append(o)
            }
         }
        
        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
        
        viewAllBtn.isEnabled = true
        viewMineBtn.isEnabled = true
        
        viewStatusBtn.setTitle(status, for: .normal)
    }
}
