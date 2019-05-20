//
//  ARSearchViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 20/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit
import ARKit

class ARSearchViewController: UIViewController, ARSKViewDelegate {
    
    let configuration = ARWorldTrackingConfiguration()
    
    var searchResult: Movie?
    
    @IBOutlet weak var arskView: ARSKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arskView.delegate = self
        
        if let scene = SKScene(fileNamed: "MyScene") {
            arskView.presentScene(scene)
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("no image found for ARWoldTrackingConfiguration")
        }
        
        configuration.detectionImages = referenceImages
        arskView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arskView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arskView.session.run(configuration)
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        if let imageAnchor = anchor as? ARImageAnchor, let referenceImageName = imageAnchor.referenceImage.name {
            print("Found image named: \(referenceImageName)")
            
            // find result from api and select first result.
            
            retrieveMoviesByTerm(searchTerm: referenceImageName)
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showARSearchInfo" {
            if let infoSearchViewController = segue.destination as? InfoSearchViewController {
                infoSearchViewController.movie = self.searchResult
            }
        }
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        
        /*
         Add api key
         */
        let apiKey = "d58c58a9" // TODO: remove before pushing to Github
        let url = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)&type=movie&r=json" // TODO: change how we get results and parse them to Movie objects
        HTTPHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.searchResult = MovieDataProcessor.mapJsonToMovies(object: object, moviesKey: "Search")[0]
                performSegue(withIdentifier: "showARSearchInfo", sender: self)
            }
        }
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
