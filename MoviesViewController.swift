//
//  MoviesViewController.swift
//  
//
//  Created by Mary Xia on 8/30/15.
//
//

import UIKit
import SwiftLoader

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var NetworkView: UIView!
    @IBOutlet weak var ReloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNetworkError()
        loadData()
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func hideNetworkError() {
        NetworkView.hidden = true
        NetworkView.frame = CGRect(x: 0, y: 64, width: 320, height: 0)
    }

    func showNetworkError() {
        NetworkView.hidden = false
        NetworkView.frame = CGRect(x: 0, y: 64, width: 320, height: 44)
    }

    func loadData() {
        SwiftLoader.show(animated: true)
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSMutableURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{ (response, data, error) in
                if (error != nil) {
                    self.showNetworkError()
                    SwiftLoader.hide()
                } else {
                    var errorValue: NSError? = nil
                    self.hideNetworkError()
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                    if let dictionary = dictionary { // If the NSDictionary type exists and wasn't set to nil
                        self.movies = dictionary["movies"] as? [NSDictionary] // ? instead of !. ? is try to cast it if it can
                        self.tableView.reloadData()
                        SwiftLoader.hide()
                    }
                }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func reloadMovies(sender: AnyObject) {
        loadData()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    // These are funcs that UITableViewDataSource requires. Since this MoviesViewController needs to be able to
    // control UITableViewDataSource, it needs to have these funcs.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies { // unwrap, movie type is correct
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]; // force unwrap

        cell.titleLabel.text = movie["title"] as? String // need to cast because it comes back as a "AnyObject"
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        // Get poster
        var urlString = movie.valueForKeyPath("posters.thumbnail") as! String
        var range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let url = NSURL(string: urlString)!
        cell.posterImageView.setImageWithURL(url)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie;
    }
}
