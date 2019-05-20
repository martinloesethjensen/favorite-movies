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
            
            //performSegue(withIdentifier: "showARSearchInfo", sender: self)
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showARSearchInfo" {
            
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
