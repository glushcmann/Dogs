//
//  FavouritesImageCell.swift
//  Dogs
//
//  Created by Никита on 01.08.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit

class FavouritesImageCell: BaseCell {
    
    var favVC = FavouritesImagesViewController()
    let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    @objc func likeTapped() {
        favVC.addToFavourite(cell: self)
    }

    override func setupViews() {
    
        addSubview(imageView)
        addSubview(likeButton)
        
        addConstrint(withVisualFormat: "H:[v0]-50-|", views: likeButton)
        addConstrint(withVisualFormat: "V:[v0]-70-|", views: likeButton)
         
        addConstrint(withVisualFormat: "H:|-10-[v0]-10-|", views: imageView)
        addConstrint(withVisualFormat: "V:|[v0]|", views: imageView)
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        
    }
}

