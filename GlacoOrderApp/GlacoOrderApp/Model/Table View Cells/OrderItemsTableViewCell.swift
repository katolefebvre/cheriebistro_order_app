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
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemModLbl: UILabel!
    @IBOutlet weak var itemQtyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
