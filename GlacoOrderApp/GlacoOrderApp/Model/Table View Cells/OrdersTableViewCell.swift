//
//  OrdersTableViewCell.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-10-12.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

/// A custom TableViewCell that stores Order information.
class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

