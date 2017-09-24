//
//  DesignableTextViews.swift
//  PokeMatch
//
//  Created by Allen Boynton on 5/23/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextViews: UITextView {
    
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
}

//class MatchedViews: UIView {
//    
//    // Creates radius corner views
//    override func awakeFromNib() {
//        self.layer.cornerRadius = 5.0
//        self.layer.borderWidth = 2.0
//        self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.8).cgColor
//        self.clipsToBounds = true
//    }
//    
//}
