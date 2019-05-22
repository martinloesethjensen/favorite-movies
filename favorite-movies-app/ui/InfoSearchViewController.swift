//
//  InfoSearchViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 20/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class InfoSearchViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var movie: Movie?
    
    var delegate = ViewController()
    
    @IBAction func addToFavorites() {
        let firebaseService = FirebaseService()
        let document = firebaseService.moviesCollection.document()
        
        firebaseService.uploadMovieToDB(movie: movie!, documentRef: document)
        
        delegate.favoriteMovies.append(movie!)
        
        // go back to favorites view controller
        tabBarController?.selectedIndex = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie?.title
        movieYear.text = movie?.year
        displayMovieImage()
    }
    
    func displayMovieImage() {
        let url: String = (URL(string: movie!.imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            // Handle threading so we don't hold up the ui thread
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                self.movieImageView?.image = image
            })
        }).resume()
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
