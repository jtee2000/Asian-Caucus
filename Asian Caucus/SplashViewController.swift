//
//  SplashViewController.swift
//  Asian Caucus
//
//  Created by Jason Tee on 4/23/19.
//  Copyright © 2019 Jason Tee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn


class SplashViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    


    @IBAction func screenPressed(_ sender: UITapGestureRecognizer) {
         performSegue(withIdentifier: "Show", sender: nil)
    }
 



}


