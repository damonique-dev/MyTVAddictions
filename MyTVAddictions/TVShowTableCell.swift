//
//  TVShowTableCell.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/19/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class TVShowTableCell: UITableViewCell {
  
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func setTitleText(title:String) {
        titleLabel.text = title
    }
    
    func setPosterImage(image:UIImage?){
        cellImage.image = image
        if image != nil {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

}
