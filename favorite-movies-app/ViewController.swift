//
//  ViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 13/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var favoriteMovies: [Movie] = []
    var selectedMovie: Movie?
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.reloadData()
        
        if favoriteMovies.count == 0 {
            // append a movie to the list
            favoriteMovies.append(Movie(id: "tt0372784", title: "Batman Begins", year: "2005", imageUrl: "https://images-na.ssl-images-amazon.com/images/M/MV5BNTM3OTc0MzM2OV5BMl5BanBnXkFtZTYwNzUwMTI3._V1_SX300.jpg"))
        }
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMoviesSegue" {
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let index = indexPath.row
        
        movieCell.movieTitle?.text = favoriteMovies[index].title
        movieCell.movieYear?.text = favoriteMovies[index].year
        displayMovieImage(index, movieCell: movieCell)
        
        return movieCell
    }
    
    func displayMovieImage(_ row: Int, movieCell: CustomTableViewCell) {
        let url: String = (URL(string: favoriteMovies[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            // Handle threading so we don't hold up the ui thread
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                movieCell.movieImageView?.image = image
            })
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

