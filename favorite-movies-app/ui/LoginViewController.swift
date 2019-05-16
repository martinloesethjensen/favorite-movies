//
//  LoginViewController.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 16/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
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
