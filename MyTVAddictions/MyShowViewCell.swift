//
//  MyShowViewCell.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 9/1/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class MyShowViewCell: UICollectionViewCell {
    @IBOutlet weak var showPoster: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    
    func setPosterImage(image:UIImage?){
        showPoster.image = image
        showTitle.hidden = true
    }
    
    func setLabelText(title: String){
        showTitle.hidden = false
        showTitle.text = title
    }
    
}
