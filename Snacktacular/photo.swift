//
//  photo.swift
//  Snacktacular
//
//  Created by wxt on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String){
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init(){
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
}