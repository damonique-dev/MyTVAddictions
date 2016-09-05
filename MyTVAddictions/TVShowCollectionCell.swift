//
//  TVShowCollectionCell.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/19/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class TVShowCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    func setPosterImage(image:UIImage?){
        cellImage.image = image
    }
}
