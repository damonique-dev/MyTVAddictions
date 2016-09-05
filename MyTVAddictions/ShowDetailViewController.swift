//
//  ShowDetailViewController.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/18/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit
import RealmSwift

class ShowDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showOverview: UILabel!
    @IBOutlet weak var episodeTableView: UITableView!
    @IBOutlet weak var seasonsTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isFavShow = false
    var show: TVShowDetail!
    var seasonList = [String]()
    var showId: Int!
    var seasonEpisodes = [[Episode]]()
    var episodes = [Episode]()
    var cast = [Cast]()
    var connection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showId = show.id
        connection = GlobalFunc.isConnectedToNetwork()
    }

    override func viewDidAppear(animated: Bool) {
        connection = GlobalFunc.isConnectedToNetwork()
        checkConnection()
    }
    
    private func checkConnection() {
        if !connection {
            if !isSavedShow(){
                displayAlert("Please connect to a network to use this feature of the app!")
            }
        } else {
            setUp()
            getShowInfo()
            getCast()
            populateFields()
        }
    }
    
    //MARK: Helper Methods
    private func setUp() {
        let pickerView = UIPickerView()
        seasonsTextField.inputView = pickerView
        
        navigationController?.navigationBar.hidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(actionPressed))
        tabBarController?.tabBar.hidden = false
        
        pickerView.delegate = self
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        scrollView.contentSize = subView.bounds.size
    }
    
    private func isSavedShow() -> Bool {
        let realm = try! Realm()
        let myShow = realm.objects(TVShowDetail.self).filter("id == \(show.id)").first
        if myShow != nil {
            isFavShow = true
            show = myShow
            cast = Array(show.cast)
            for season in show.seasons {
                if season.seasonNum != 0 {
                    seasonList.append("Season \(season.seasonNum)")
                    seasonEpisodes.append(Array(season.episodes))
                }
            }
            episodes = self.seasonEpisodes[0]
            episodeTableView.reloadData()
            setUp()
            populateFields()
            return true
        }
        return false
    }
    
    private func getShowInfo() {
        let seasons = show.seasons
        for season in seasons {
            let num = season.seasonNum
            if num != 0 {
                if season.episodes.count == 0 {
                    TMDBClient.sharedInstance().getTVSeasonInfo(String(showId), seasonNum: String(num)) { (results, error) in
                        if results != nil {
                            for result in results! {
                                season.episodes.append(result)
                            }
                            self.seasonEpisodes.append(results!)
                            if self.seasonEpisodes.count == 1 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.episodes = self.seasonEpisodes[0]
                                    self.episodeTableView.reloadData()
                                }
                            }
                        }
                    }
                } else {
                    seasonEpisodes.append(Array(season.episodes))
                }
                seasonList.append("Season \(num)")
            }
            
        }
        
    }
    
    func displayAlert(message:String){
        let alertView = UIAlertController(title: "Uh-Oh", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func getCast() {
        TMDBClient.sharedInstance().getTVShowCast(String(showId)) { (results, error) in
            if results != nil {
                for result in results! {
                    self.show.cast.append(result)
                }
                self.cast = results!
                self.collectionView.reloadData()
            }
        }
    }
    
    private func populateFields() {
        showTitle.text = show.title
        showOverview.text = show.overview
        episodeTableView.setContentOffset(CGPointZero, animated:true)
        if show.posterImageData == nil && connection {
            let photoUrl = TMDBClient.Constants.ImageURL + show.posterPath
            TMDBClient.sharedInstance().getPhoto(photoUrl) { (imageData) in
                if imageData != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showImage.image = UIImage(data: imageData!)!
                    }
                }
            }
        } else {
            showImage.image = UIImage(data: show.posterImageData!)!
        }
        
        seasonsTextField.text = seasonList[0]
    }
    
    func actionPressed () {
        let alert = UIAlertController(title: show.title, message: nil, preferredStyle: .ActionSheet)
        var firstActionText = ""
        
        if isFavShow == true {
            firstActionText = "Remove from My Shows"
        }
        else {
            firstActionText = "Add to My Shows"
        }
        let favShow = UIAlertAction(title: firstActionText, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.manageMyShows()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(favShow)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    private func manageMyShows() {
        let realm = try! Realm()
        if isFavShow == true {
            try! realm.write {
                realm.delete(show!)
            }
        }
        else {
            try! realm.write {
                realm.add(show)
                
            }
        }
    }
    
    //MARK: Picker View Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seasonList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seasonList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        episodes = seasonEpisodes[row]
        seasonsTextField.text = seasonList[row]
        episodeTableView.reloadData()
        seasonsTextField.resignFirstResponder()
    }
    
    //MARK: Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell")!
        let ep = episodes[indexPath.row]
        let text = "\(ep.episodeNum). \(ep.name)"
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = episodes[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("episodeDetail") as! EpisodeDetailViewController
        controller.showId = String(showId)
        controller.seasonNum = seasonsTextField.text?.componentsSeparatedByString(" ").last
        controller.episode = episode
        navigationController!.pushViewController(controller, animated: true)
    }
    
    //MARK: Collection View functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("castCell", forIndexPath: indexPath) as! CastViewCell
        let actor = cast[indexPath.row]
        cell.setNameText(actor.name)
        if actor.imageData != nil {
            if actor.imageData!.length != 0 {
                cell.setImage(UIImage(data: actor.imageData!)!)
            }
        } else {
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
        
        return cell
    }
}
