//
//  DesignableImageViews.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/23/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageViews: UIImageView {
    
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

//class BorderImageView: UIImageView {
//    
//    // Creates rounded image views for tiles
//    override func awakeFromNib() {
//        self.layer.cornerRadius = 3.0
//        self.layer.borderWidth = 2.0
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.clipsToBounds = true
//    }
//}
