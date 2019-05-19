//
//  InfoViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 19/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYear: UILabel!
    
    var movie: Movie?
    
    @IBAction func removeFromFavorites(sender: UIButton) {
        print("hello")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieTitle.text = movie?.title ?? "HEjejeje"
        movieYear.text = movie?.year ?? "HHDujskdnskjd"
        //displayMovieImage()
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
