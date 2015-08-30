//
//  MoviesViewController.swift
//  
//
//  Created by Mary Xia on 8/30/15.
//
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSMutableURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(
                request,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{ (response, data, error) in
                    var errorValue: NSError? = nil
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                    if let dictionary = dictionary { // If the NSDictionary type exists and wasn't set to nil
                        self.movies = dictionary["movies"] as? [NSDictionary] // ? instead of !. ? is try to cast it if it can
                        self.tableView.reloadData()
                    }
        })
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
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
