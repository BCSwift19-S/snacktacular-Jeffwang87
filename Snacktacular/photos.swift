//
//  photos.swift
//  Snacktacular
//
//  Created by wxt on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
}
