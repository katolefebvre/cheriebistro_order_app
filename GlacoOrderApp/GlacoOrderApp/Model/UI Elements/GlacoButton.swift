//
//  GlacoButton.swift
//  GlacoOrderApp
//
//  Created by Kato Lefebvre on 2020-11-08.
//  Copyright © 2020 GLAC Co. All rights reserved.
//

import UIKit

@IBDesignable class GlacoButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            self.layer.cornerRadius = frame.size.height / 2
            self.layer.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
            self.setTitleColor(.link, for: .normal)
            self.setTitleColor(.gray, for: .disabled)
        }
    }
}
