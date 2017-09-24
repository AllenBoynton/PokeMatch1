//
//  ImageLoader.swift
//  PokéMatch
//
//  Created by Allen Boynton on 5/29/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import UIKit.UIImage

var image: UIImage? = nil

extension UIImage {
    static func downloadImage(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                image = UIImage(data: data!)
            })
            
        }).resume()
    }
}
