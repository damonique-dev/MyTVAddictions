//
//  EpisodeDetailViewController.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/25/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit
import RealmSwift

class EpisodeDetailViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var showId:String!
    var seasonNum: String!
    var episode: Episode!
    var cast = [Cast]()
    var alertShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        if !GlobalFunc.isConnectedToNetwork() {
            displayAlert("Please connect to a network to use this feature of the app!")
        } else {
            getCast()
            populateFields()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.topItem?.title = episode.name
    }
    
    private func populateFields() {
        overviewLabel.text = "\(episode.overview). \n-- Air date: \(episode.airDate)"
        let photoUrl = TMDBClient.Constants.ImageURL + episode.imagePath
        if checkConnection() {
        TMDBClient.sharedInstance().getPhoto(photoUrl) { (imageData) in
            if imageData != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.episodeImageView.image = UIImage(data: imageData!)!
                }
            }
        }
        }
    }
    
    private func getCast() {
        if checkConnection() {
        TMDBClient.sharedInstance().getTVSeasonCast(showId, seasonNum: seasonNum) { (results, error) in
            if results != nil {
                for result in results! {
                    self.cast.append(result)
                }
                for member in self.episode.guestCast {
                    self.cast.append(member)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
            }
            if error != nil {
                self.displayAlert((error?.localizedDescription)!)
            }
        }
        }
    }
    
    //MARK: Collection View functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("episodeCastCell", forIndexPath: indexPath) as! EpisodeCastViewCell
        let actor = cast[indexPath.row]
        cell.setNameText(actor.name)
        if actor.imageData != nil {
            if actor.imageData!.length != 0 {
                cell.setImage(UIImage(data: actor.imageData!)!)
            }
        } else {
            if checkConnection() {
            let photoUrl = TMDBClient.Constants.ImageURL + actor.imagePath
            TMDBClient.sharedInstance().getPhoto(photoUrl) { (imageData) in
                if imageData != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.setImage(UIImage(data: imageData!)!)
                        let realm = try! Realm()
                        try! realm.write() {
                            actor.imageData = imageData
                        }
                    }
                }
            }
            }
        }
        
        return cell
    }
}

extension EpisodeDetailViewController {
    func displayAlert(message:String){
        if !alertShowing {
            alertShowing = true
            let alertView = UIAlertController(title: "Uh-Oh", message: message, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default){ (alert: UIAlertAction!) -> Void in
                self.alertShowing = false
                })
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func checkConnection() -> Bool {
        if !GlobalFunc.isConnectedToNetwork() {
            displayAlert("Please connect to a network to use this feature of the app!")
            return false
        } else {
            return true
        }
    }
}
