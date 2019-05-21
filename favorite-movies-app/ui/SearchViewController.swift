//
//  SearchViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 13/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchText: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var selectedMovie: Movie?
    
    var delegate = ViewController()
    
    lazy var firebaseService = FirebaseService()
    
    var searchResults = [Movie]()
    
    @IBAction func search(sender: UIButton) {
        print("Searching for \(self.searchText.text!)")
        
        // Trimming search term
        let searchTerm = searchText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchTerm.count > 2 {
            retrieveMoviesByTerm(searchTerm: searchTerm)
        }
        
        searchText.resignFirstResponder()
    }
    
    @IBAction func addFavorite(sender: UIButton) {
        let document = firebaseService.moviesCollection.document()
        let movie = searchResults[sender.tag]
        
        print("Item \(sender.tag) was selected as a favorite.")
        
        //Add movie to list in ViewController class
        self.delegate.favoriteMovies.append(movie)
        
        // Upload to firebase
        firebaseService.uploadMovieToDB(movie:movie, documentRef: document)
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        
        /*
         Add api key
         */
        let apiKey = "d58c58a9" // TODO: remove before pushing to Github
        let url = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)&type=movie&r=json" // TODO: change how we get results and parse them to Movie objects
        HTTPHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = searchResults[indexPath.row]
        
        performSegue(withIdentifier: "showSearchDetail", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchDetail" {
            if let infoSearchViewController = segue.destination as? InfoSearchViewController {
                infoSearchViewController.movie = self.selectedMovie
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // at init/appear ... this runs for each visible cell that needs to render
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let index: Int = indexPath.row
        movieCell.addToFavoriteButton.tag = index
        
        DispatchQueue.main.async {
            //title
            movieCell.movieTitle?.text = self.searchResults[index].title
            //year
            movieCell.movieYear?.text = self.searchResults[index].year
        }
        
        // image
        displayMovieImage(index, movieCell: movieCell)
        
        return movieCell
    }
    
    func displayMovieImage(_ row: Int, movieCell: CustomTableViewCell) {
        let url: String = (URL(string: searchResults[row].imageUrl)?.absoluteString)!
        
        // Creates a task to retrieve content from url
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            // For not blocking
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                movieCell.movieImageView?.image = image
            })
        }).resume() // resume task if it's suspended
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.searchResults = MovieDataProcessor.mapJsonToMovies(object: object, moviesKey: "Search")
                
                // Update tableView without blocking
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
