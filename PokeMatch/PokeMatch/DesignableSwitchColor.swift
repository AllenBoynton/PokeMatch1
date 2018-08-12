//
//  DesignableSwitchColor.swift
//  PokéMatch
//
//  Created by Allen Boynton on 7/6/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

@IBDesignable class UISwitchColor: UISwitch {
    
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
