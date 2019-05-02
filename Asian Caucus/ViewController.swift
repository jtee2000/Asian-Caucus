//
//  ViewController.swift
//  Asian Caucus
//
//  Created by Jason Tee on 4/22/19.
//  Copyright © 2019 Jason Tee. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var eventImage: UIImageView!
    
    var authUI: FUIAuth!
    var defaultsData = UserDefaults.standard
    var event: Event!
    var events: Events!
    var dateArray = [String]()

    var index = -1
    var imageindex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton.isEnabled = false
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateArray = defaultsData.stringArray(forKey: "dateArray") ?? [String]()
        
        if event == nil {
            event = Event()
        }
        
        events = Events()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvent" {
            let destination = segue.destination as! EventViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            destination.event = events.eventArray[selectedIndex]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        events.loadData() {
            self.tableView.reloadData()
        }
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
        
    }
    
    @IBAction func adminLoginPressed(_ sender: UIBarButtonItem) {
        signIn()
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            signIn()
            addBarButton.isEnabled = false
        } catch {
            print("*** ERROR: Couldn't sign out")
        }
    }
    
    @IBAction func swipeImage(_ sender: UISwipeGestureRecognizer) {
        if index == 26 {
            index = -1
        }
        index+=1
        eventImage.image = UIImage(named: "image\(index)")
    }
    
    
    
    
//    func saveDefaultsData() {
//        defaultsData.set(dateArray, forKey: "dateArray")
//    }
//
//    @IBAction func unwindFromDetailViewController(segue:UIStoryboardSegue) {
//        let sourceViewController = segue.source as! DetailViewController
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        } else {
//            let newIndexPath = IndexPath(row: events.eventArray.count, section: 0)
//            dateArray.append(sourceViewController.subtitle!)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//        }
//        saveDefaultsData()
//    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = events.eventArray[indexPath.row].eventTitle
        cell.detailTextLabel?.text = "\(events.eventArray[indexPath.row].location) ~ \(events.eventArray[indexPath.row].time)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            events.eventArray.remove(at: indexPath.row)
//            dateArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
//    }
    
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            //If you try to use any other email besides your BC email, you can't add any events (i.e. only admins use)
            if user.email == "teej@bc.edu" || user.email == "gallaugh@bc.edu" {
                addBarButton.isEnabled = true
                print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
            }

        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.black
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "AC_LOGO")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
    
    


