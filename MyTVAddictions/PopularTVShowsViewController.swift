//
//  ViewController.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/16/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class PopularTVShowsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tvShows = [TVShow]()
    var alertShowing = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false;
        navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = true
        checkConnection()
    }
    
    private func checkConnection() {
        navigationController?.navigationBar.hidden = true
        if !GlobalFunc.isConnectedToNetwork() {
            displayAlert("Please connect to a network to use this feature of the app!")
            warningLabel.hidden = false
        } else {
            warningLabel.hidden = true
            getShows()
        }
    }
    
    //MARK: Helper Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            let controller = segue.destinationViewController as! ShowDetailViewController
            let show = sender as! TVShowDetail
            controller.show = show
        }
    }
    
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
    
    func getShows () {
        TMDBClient.sharedInstance().getPopularTVShows() { (results, error) in
            if error != nil {
                 self.displayAlert((error?.localizedDescription)!)
                self.tvShows = []
            } else {
                self.tvShows = results!
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
    }
    
    //MARK: Table View Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")! as! TVShowTableCell
        let show = tvShows[indexPath.row]
        cell.setTitleText(show.title)
        cell.setPosterImage(nil)
        if show.backdropImageData.length != 0 {
            cell.setPosterImage(UIImage(data: show.backdropImageData)!)
        } else {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                var photoUrl = ""
                if show.backdropPath != "" {
                    photoUrl = TMDBClient.Constants.ImageURL + show.backdropPath
                } else {
                    photoUrl = TMDBClient.Constants.ImageURL + show.posterPath
                }
                TMDBClient.sharedInstance().getPhoto(photoUrl) { (imageData) in
                    if imageData != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            show.backdropImageData = imageData!
                            cell.setPosterImage(UIImage(data: imageData!)!)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let show = tvShows[indexPath.row]
        TMDBClient.sharedInstance().getTvShowInfo(String(show.id)) { (results, error) in
            if results != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("details", sender: results)
                }
            } else {
                self.displayAlert((error?.localizedDescription)!)
            }
        }
    }
}

