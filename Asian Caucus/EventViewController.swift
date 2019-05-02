//
//  EventViewController.swift
//  Asian Caucus
//
//  Created by Jason Tee on 4/26/19.
//  Copyright © 2019 Jason Tee. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterfaace()
        // Do any additional setup after loading the view.
    }
    
    func updateUserInterfaace() {
        eventLabel.text = event.eventTitle
        descriptionField.text = event.eventDescription
    }
    



}
