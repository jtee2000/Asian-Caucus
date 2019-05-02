//
//  DetailViewController.swift
//  Asian Caucus
//
//  Created by Jason Tee on 4/24/19.
//  Copyright © 2019 Jason Tee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var eventField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var flyerImage: UIImageView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
//    var eventName: String?
//    var date: String?
//    var location: String?
//    var subtitle: String?
    var imagePicker = UIImagePickerController()
    var events = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if events == nil {
            events = Event()
        }
        enableDisableSaveButton()
        updateUserInterface()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UnwindFromSave" {
//            eventName = eventField.text
//            location = locationField.text
//            date = dateFormatter(viewPicker: dateField)
//            subtitle = "\(location!) ~ \(date!)"
//
//
//        }
//    }
    
    func updateUserInterface () {
        eventField.text = events.eventTitle
        descriptionField.text = events.eventDescription
        locationField.text = events.location
    }
    
    func dateFormatter(viewPicker: UIDatePicker) -> String {
        let date = viewPicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func enableDisableSaveButton() {
        if let eventFieldCount = eventField.text?.count, eventFieldCount > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        flyerImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateDataFromInterface() {
        events.eventTitle = eventField.text!
        events.eventDescription = descriptionField.text!
        events.location = locationField.text!
        events.time = dateFormatter(viewPicker: dateField)
    }

    @IBAction func eventFieldChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func aboutACPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowAC", sender: nil)
        
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        self.updateDataFromInterface()
        events.saveData() { success in
            if success {
                self.leaveViewController()
            } else {
                print("Can't segue because of the error")
            }
        }
    }
    
}

