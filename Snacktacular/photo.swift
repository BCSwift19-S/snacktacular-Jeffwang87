//
//  photo.swift
//  Snacktacular
//
//  Created by wxt on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var documentUUID: String
    var dictionary: [String: Any]{
        return ["description":description, "postedBy": postedBy]
    }
    
    init(image: UIImage, description: String, postedBy: String, documentUUID: String){
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.documentUUID = documentUUID
    }
    
    convenience init(){
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        self.init(image: UIImage(), description: description, postedBy: postedBy, documentUUID: "")
    }
    
    
    func saveData(spot:Spot, completed: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else{
            print("*** ERROR: Could not Convert")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString
        
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata)
        {metadata, error in
            guard error == nil else {
                print("Error")
                return
            }
            print("upload work")
            
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) {(error) in
                if let error = error {
                    completed(false)
                } else {
                    completed(true)
                }
                
            }
        }
        uploadTask.observe(.failure){(snapshot) in
            if let error = snapshot.error{
                print("ERROR can't upload")
            }
            return completed(false)
        }
      
        
    }
}
