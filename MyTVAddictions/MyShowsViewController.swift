//
//  MyShowsViewController.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 9/1/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit
import RealmSwift

class MyShowsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var myShows = [TVShowDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false;
        pageSetUp()
    }
    
    override func viewDidAppear(animated: Bool) {
        pageSetUp()
    }
    
    //MARK: Helper Methods
    private func displayAlert(message:String){
        let alertView = UIAlertController(title: "Uh-Oh", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destinationViewController as! ShowDetailViewController
            let show = sender as! TVShowDetail
            controller.show = show
        }
    }
    
    private func pageSetUp() {
        navigationController?.navigationBar.hidden = true
        let results = try! Realm().objects(TVShowDetail)
        myShows = Array(results)
        if myShows.count == 0 {
            noResultsLabel.hidden = false;
        } else {
            collectionView.reloadData()
            noResultsLabel.hidden = true;
        }
    }
    
    private func isSavedShow(showId: Int) -> TVShowDetail? {
        let realm = try! Realm()
        let myShow = realm.objects(TVShowDetail.self).filter("id == \(showId)").first
        return myShow
    }
    
    //MARK: Collection View functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myShows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("myShowCell", forIndexPath: indexPath) as! MyShowViewCell
        let show = myShows[indexPath.row]
        cell.setPosterImage(nil)
        if show.posterImageData != nil {
            if show.posterImageData!.length != 0 {
                cell.setPosterImage(UIImage(data: show.posterImageData!)!)
            }
        } else {
            let photoUrl = TMDBClient.Constants.ImageURL + show.posterPath
                TMDBClient.sharedInstance().getPhoto(photoUrl) { (imageData) in
                    if imageData != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.setPosterImage(UIImage(data: imageData!)!)
                            let realm = try! Realm()
                            try! realm.write() {
                                show.posterImageData = imageData
                            }
                        }
                    } else {
                        cell.setLabelText(show.title)
                    }
                }
            }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let show = myShows[indexPath.row]
        if let myshow = isSavedShow(show.id) {
            performSegueWithIdentifier("showDetail", sender: myshow)
        } else {
            TMDBClient.sharedInstance().getTvShowInfo(String(show.id)) { (results, error) in
                if results != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("showDetail", sender: results)
                    }
                } else {
                    self.displayAlert((error?.localizedDescription)!)
                }
            }
        }
    }
    
}
