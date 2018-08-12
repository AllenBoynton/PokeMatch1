//
//  DesignableButtons.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/24/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

// Creates rounded buttons for choice buttons
@IBDesignable class DesignableButtons: UIButton {
    
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
