//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by wxt on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit
import Firebase

class ReviewTableViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var reviewTitleField: UITextField!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    
    @IBOutlet var satrButtonCollection: [UIButton]!
    
    var spot: Spot!
    var review: Review!
    var rating = 0 {
        didSet {
            for starButton in satrButtonCollection {
                let image = UIImage(named: (starButton.tag < rating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.rating = rating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard let spot = spot else {
            print("ERROR")
            return
        }
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        if review == nil {
            review = Review()
        }
        updateuserinterface()
}
    func updateuserinterface() {
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        rating = review.rating
        reviewTitleField.text = review.title
        enableDisableSaveButton()
        reviewTextView.text = review.text
        if review.documentID == ""{
            addBoardersToEditableObjects()
        } else {
            if review.reviewUserID == Auth.auth().currentUser?.email {
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "update"
                addBoardersToEditableObjects()
                deleteButton.isHidden = false
            } else{
                cancelBarButton.title = ""
                saveBarButton.title = ""
                postedByLabel.text = "\(review.reviewUserID)"
                for starButton in satrButtonCollection{
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTitleField.backgroundColor = UIColor.white
                }
                
            }
        }
    }
    func addBoardersToEditableObjects() {
        reviewTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        buttonsBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func enableDisableSaveButton(){
        if reviewTitleField.text != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

    
    @IBAction func StarButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
        
    }
    
    @IBAction func ReturnTitleDonePressed(_ sender: UITextField) {
    }
    
    @IBAction func ReviewTitleChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        review.deleteData(spot: spot){(success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR")
            }
            
        }
    }
    
    @IBAction func savebuttonpressed(_ sender: UIBarButtonItem) {
        review.title = reviewTitleField.text!
        review.text = reviewTextView.text!
        review.saveData(spot: spot) {(success) in
            if success {
                self.leaveViewController()
            } else {
                print("Error")
            }
            
        }
    }
    
    @IBAction func Cancelbuttonpressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
}
