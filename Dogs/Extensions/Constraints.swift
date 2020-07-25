//
//  Constraints.swift
//  Dogs
//
//  Created by Никита on 25.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstrint(withVisualFormat: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: withVisualFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


