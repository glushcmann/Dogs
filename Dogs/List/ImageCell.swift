//
//  ImageCell.swift
//  Dogs
//
//  Created by Никита on 25.07.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
    }
}

class ImageCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override func setupViews() {
    
        addSubview(imageView)
        
        addConstrint(withVisualFormat: "H:|[v0]|", views: imageView)
        addConstrint(withVisualFormat: "V:|-200-[v0]-200-|", views: imageView)
        
    }
}
