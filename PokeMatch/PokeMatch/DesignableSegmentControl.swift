//
//  DesignableSegmentControl.swift
//  PokéMatch
//
//  Created by Allen Boynton on 6/27/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

@IBDesignable class DesignableSegmentedControl: UISegmentedControl {
    
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
    
    // Creates custom font attributes
    override func awakeFromNib() {
        
        // Change font and size within segments
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Medium", size: 13.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
        
        // Change color for segment selected text
        let segAttributes: NSDictionary = [
            NSAttributedStringKey.foregroundColor: UIColor.orange,
            NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        ]
        
        setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
    }
}

