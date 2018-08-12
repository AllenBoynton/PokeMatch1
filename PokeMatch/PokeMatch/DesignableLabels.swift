//
//  DesignableLabels.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/23/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

@IBDesignable class DesignableLabels: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = masksToBounds
        }
    }
}
//class RoundedLabels: UILabel {
//    
//    // Creates rounded buttons for choice buttons
//    override func awakeFromNib() {
//        self.layer.cornerRadius = 3.0
//        self.layer.borderWidth = 2.0
//        self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0).cgColor
//        self.layer.masksToBounds = true
//    }
//}
