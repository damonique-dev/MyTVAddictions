//
//  SearchViewController.swift
//  MyTVAddictions
//
//  Created by Damonique Thomas on 8/20/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var tvShows = [TVShow]()
    var alertShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        noResultsLabel.hidden = false
        searchBar.userInteractionEnabled = true
        navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = true
        checkConnection()
    }
    
    private func checkConnection() {
        if !GlobalFunc.isConnectedToNetwork() {
            displayAlert("Please connect to a network to use this feature of the app!")
            searchBar.userInteractionEnabled = false
        }
    }
    
    //MARK: Helper Methods
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            noResultsLabel.hidden = true
            TMDBClient.sharedInstance().searchTV(searchText) { (results, error) in
                if error != nil {
                    self.displayAlert((error?.localizedDescription)!)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tvShows = results!
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if searchText.isEmpty {
            noResultsLabel.hidden = false
            tvShows.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
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
    
    //MARK - Table functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell")!
        let show = tvShows[indexPath.row]
        cell.textLabel!.text = show.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let show = tvShows[indexPath.row]
        TMDBClient.sharedInstance().getTvShowInfo(String(show.id)) { (results, error) in
            if results != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("showDetails", sender: results)
                }
            } else {
                self.displayAlert((error?.localizedDescription)!)
            }
        }

    }
}
