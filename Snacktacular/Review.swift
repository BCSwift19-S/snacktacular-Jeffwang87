//
//  Review.swift
//  Snacktacular
//
//  Created by wxt on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review{
    var title: String
    var text: String
    var rating: Int
    var reviewUserID: String
    var documentID: String
    
    var dictionary: [String: Any]{
        return ["title": title, "text": text, "rating": rating, "reviewUserID":
            reviewUserID, "documentID": documentID]
        
    }
    
    init(title: String, text: String, rating: Int, reviewUserID: String, documentID: String){
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewUserID = dictionary["reviewUserID"] as! String
        self.init(title: title, text: text, rating: rating, reviewUserID: reviewUserID, documentID: "")

    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "unknown User"
        self.init(title: "", text: "", rating: 0, reviewUserID: currentUserID, documentID: "")
    }
    
    func saveData(spot:Spot, completed: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        
        let dataToSave = self.dictionary
        if self.documentID != ""{
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) {(error) in
                if let error = error {
                    completed(false)
                } else {
                    spot.updateAverageRating {
                        completed(true)
                    }
                }
                
            }
        }else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error
                in
                if let error = error {
                    completed(false)
                } else {
                    spot.updateAverageRating {
                        completed(true)
                    }
                }
            }
            
        }
        
    }
    
    func deleteData(spot: Spot, completed: @escaping(Bool) -> ()){
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("reviews").document(documentID).delete()
            { error in
                if let error = error {
                    print("ERROR: deleting review documentID")
                    completed(false)
                }else {
                    spot.updateAverageRating {
                        completed(true)
                    }
                }
            }
    }
}
