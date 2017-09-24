//
//  DropShadow.swift
//  PokéMatch
//
//  Created by Allen Boynton on 7/20/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit

protocol DropShadow {}

extension DropShadow where Self: UIView {
    
    func addDropShadow() {
        // implementation
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6
    }
}

