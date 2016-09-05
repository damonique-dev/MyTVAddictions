//
//  CastViewCell.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 9/5/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class CastViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / 3
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func setNameText(name:String){
        nameLabel.text = name
    }
    
    func setImage(image:UIImage?){
        imageView.image = image
        if image != nil {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
}
