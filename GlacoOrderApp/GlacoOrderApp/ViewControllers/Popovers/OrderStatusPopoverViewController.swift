//
//  OrderStatusPopoverViewController.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-11-19.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

class OrderStatusPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var controllerDelegate : OrderStatusPopoverControllerDelegate?
    var statuses : [String] = ["Pending", "Confirmed", "In Progress", "Served", "Paid", "Cancelled"]
    @IBOutlet var statusTable : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : DatabaseIdTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "status") as? DatabaseIdTableViewCell ?? DatabaseIdTableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "status")
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .systemBlue
        
        tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        tableCell?.textLabel?.text = statuses[indexPath.row]
        tableCell?.selectedBackgroundView = cellBackgroundView
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controllerDelegate?.setOrderStatus(status: statuses[indexPath.row])
    }
}
