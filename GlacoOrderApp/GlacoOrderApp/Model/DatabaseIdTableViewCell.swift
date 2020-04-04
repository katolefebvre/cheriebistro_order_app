//
//  DatabaseIdTableViewCell.swift
//  GlacoOrderApp
//
//  Created by Parker Christie on 2020-03-24.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

/// A custom TableViewCell that stores a database ID as a parameter to be accessed by anyone.
class DatabaseIdTableViewCell: UITableViewCell {
    
    public var databaseId : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
