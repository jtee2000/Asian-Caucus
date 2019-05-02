//
//  Event.swift
//  Asian Caucus
//
//  Created by Jason Tee on 4/28/19.
//  Copyright © 2019 Jason Tee. All rights reserved.
//
import Firebase
import Foundation

class Event {
    var eventTitle: String
    var eventDescription: String
    var location: String
    var time: String
    var postingUserID: String
    var createdOn: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = createdOn.timeIntervalSince1970
        return ["eventTitle": eventTitle, "eventDescription": eventDescription, "location": location, "time": time,
                "createdOn": timeIntervalDate, "postingUserID": postingUserID]
    }
    
    init(eventTitle: String, eventDescription: String, location: String, time: String, createdOn: Date, postingUserID: String, documentID: String)
    {
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.location = location
        self.time = time
        self.createdOn = createdOn
        self.postingUserID = postingUserID
        self.documentID = documentID
    
    }
    convenience init() {
        self.init(eventTitle: "", eventDescription: "", location: "", time: "", createdOn: Date(), postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let eventTitle = dictionary["eventTitle"] as! String? ?? ""
        let eventDescription = dictionary["eventDescription"] as! String? ?? ""
        let location = dictionary["location"] as! String? ?? ""
        let time = dictionary["time"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let createdOn = Date(timeIntervalSince1970: timeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(eventTitle: eventTitle, eventDescription: eventDescription, location: location, time: time, createdOn: createdOn, postingUserID: postingUserID, documentID: "")
    }
    
    
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("events").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("events").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
}

