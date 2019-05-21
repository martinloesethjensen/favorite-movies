//
//  InfoViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 19/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    
    var movie: Movie?
    
    @IBAction func removeFromFavorites(sender: UIButton) {
        let firebaseService = FirebaseService()
        
        // deleting movie from database
        firebaseService.deleteMovieFromDB(movieId: movie!.id)
        
        // go back to previous view controller
        _ = navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.movieTitle.text = self.movie?.title ?? "{{Title}}"
            self.movieYear.text = self.movie?.year ?? "{{Year}}"
        }
        displayMovieImage()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
