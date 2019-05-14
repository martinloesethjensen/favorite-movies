//
//  SearchViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 13/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchText: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addToFavoriteButton: UIButton!
    
    var searchResults = [Movie]()
    
    @IBAction func search(sender: UIButton) {
        print("Searching for \(self.searchText.text!)")
        
        let searchTerm = searchText.text!
        if searchTerm.count > 2 {
            retrieveMoviesByTerm(searchTerm: searchTerm)
        }
        
        searchText.resignFirstResponder()
    }
    
    @IBAction func addFavorite(sender: UIButton) {
        
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        
        /*
         Add api key
         */
        let apiKey = ""
        let url = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)&type=movie&r=json"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // at init/appear ... this runs for each visible cell that needs to render
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let index: Int = indexPath.row
        movieCell.addToFavoriteButton.tag = index
        
        //title
        movieCell.movieTitle?.text = searchResults[index].title
        //year
        movieCell.movieYear?.text = searchResults[index].year
        // image
        displayMovieImage(index, movieCell: movieCell)
        
        return movieCell
    }
    
    func displayMovieImage(_ row: Int, movieCell: CustomTableViewCell) {
        let url: String = (URL(string: searchResults[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                movieCell.movieImageView?.image = image
            })
        }).resume()
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.searchResults = MovieDataProcessor.mapJsonToMovies(object: object, moviesKey: "Search")
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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
