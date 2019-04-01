//
//  Spot.swift
//  Snacktacular
//
//  Created by wxt on 3/30/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class Spot: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberofReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longtitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    var dictionary: [String: Any]{
        return ["name": name, "address": address, "longtitude": longtitude, "latitude": latitude, "averageRating": averageRating, "numberofReviews": numberofReviews, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberofReviews: Int, postingUserID: String, documentID: String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberofReviews = numberofReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
        
    }
    convenience override init(){
     self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberofReviews: 0, postingUserID: "", documentID: "")
    }
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longtitude = dictionary["longtitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberofReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberofReviews: numberofReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            return completed(false)
        }
        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != ""{
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) {(error) in
                if let error = error {
                    completed(false)
                } else {
                    completed(true)
                }
                
            }
        }else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave) { error
                in   if let error = error {
                    completed(false)
                } else {
                    completed(true)
                }
            }
            
        }
        
    }
}
