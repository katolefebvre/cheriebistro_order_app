//
//  OrderItemsTableViewCell.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-13.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

/// A custom TableViewCell that stores Order Item information.
class OrderItemsTableViewCell: UITableViewCell {
    
    var orderItem: OrderItem!
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemQtyLbl: UILabel!
    @IBOutlet weak var itemModTf: UITextField!
    @IBOutlet weak var itemQtyStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        orderItem?.quantity = Int(sender.value)
        itemQtyLbl.text = Int(sender.value).description
    }
}
