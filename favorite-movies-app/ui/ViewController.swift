//
//  ViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 13/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var favoriteMovies = [Movie]()
    var selectedMovie: Movie!
    var currentMovieIndex = 0
    
    @IBOutlet var mainTableView: UITableView!
    
    lazy var firebaseService = FirebaseService()
    
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

        firebaseService.moviesCollection.addSnapshotListener { (snapshot, error) in

            self.favoriteMovies.removeAll()

            for document in snapshot!.documents {
                if let title = document.data()["title"] as? String,
                   let imageUrl = document.data()["imageUrl"] as? String,
                   let year = document.data()["year"] as? String,
                   let id = document.documentID as? String {
                    let movie = Movie(id: id, title: title, year: year, imageUrl: imageUrl)
                    self.favoriteMovies.append(movie)
                    print("received \(title)")
                }
            }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = favoriteMovies[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let infoViewController = segue.destination as? InfoViewController {
                infoViewController.movie = self.selectedMovie
            }
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted: \(favoriteMovies[indexPath.row].title)\n\tdocument id: \(favoriteMovies[indexPath.row].id)")

            let movieDocumentId = favoriteMovies[indexPath.row].id

            // delete from firebase first
            firebaseService.deleteMovieFromDB(movieId: movieDocumentId)

            // delete from list and remove row from table view
            self.favoriteMovies.remove(at: indexPath.row)
            self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

