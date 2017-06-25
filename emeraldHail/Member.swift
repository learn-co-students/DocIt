//
//  Member.swift
//  addMembers
//
//  Created by Mirim An on 11/19/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Member {
    
    var profileImage: String
    var firstName: String
    var lastName: String
    var gender: String
    var birthday: String
    var bloodType: String
    var height: String
    var weight: String
    var allergies: String
    var id: String
    
    init(profileImage: String, firstName: String, lastName: String, gender: String , birthday: String,  bloodType: String, height: String, weight: String, allergies: String, id: String) {
        self.profileImage = profileImage
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.bloodType = bloodType
        self.height = height
        self.weight = weight
        self.allergies = allergies
        self.id = id
    }
    
    init(dictionary: [String : Any], id: String) {
        profileImage = dictionary["profileImage"] as? String ?? "No Image URL"
        firstName = dictionary["firstName"] as? String ?? "No Name"
        lastName = dictionary["lastName"] as? String ?? "No Last Name"
        gender = dictionary["gender"] as? String ?? "No Gender"
        birthday = dictionary["birthday"] as? String ?? "No Birthday"
        bloodType = dictionary["bloodType"] as? String ?? "No Blood Type"
        height = dictionary["height"] as? String ?? "No Height"
        weight = dictionary["weight"] as? String ?? "No Weight"
        allergies = dictionary["allergies"] as? String ?? "No Allergies"
        self.id = id
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as? [String : AnyObject]
        
        profileImage = snapshotValue?["profileImage"] as? String ?? "No Image URL"
        firstName = snapshotValue?["firstName"] as? String ?? "No First Name"
        lastName = snapshotValue?["lastName"] as? String ?? "No Last Name"
        gender = snapshotValue?["gender"] as? String ?? "No Gender"
        birthday = snapshotValue?["birthday"] as? String ?? "No Birthday"
        bloodType = snapshotValue?["bloodType"] as? String ?? "No Bloodtype"
        height = snapshotValue?["height"] as? String ?? "No Height"
        weight = snapshotValue?["weight"] as? String ?? "No Weight"
        allergies = snapshotValue?["allergies"] as? String ?? "No Allergies"
        id = snapshotValue?["uniqueID"] as? String ?? "No ID"
    }
    
    func serialize() -> [String : Any] {
        return  ["profileImage" : profileImage, "firstName" : firstName, "lastName": lastName, "gender" : gender, "birthday" : birthday,  "bloodType": bloodType, "height": height, "weight": weight, "allergies": allergies,  "uniqueID" : id]
    }
    
    func saveToFireBase(handler: (Bool) -> Void) {
        // TODO:
        // get the firebase ref through the shared manager
        // updateValue should be called but on the right ref. child("VALUE") replacing value with the correct location
        // call update value on that ref then in that completion handler of that, if successfull, call handler here and pass in true.
    }
}
extension Member {

    static func saveMember(button: UIButton,
                           imageView: UIImageView,
                           firstName: String?,
                           lastName: String?,
                           dob: String?,
                           gender: String?,
                           controller: UIViewController) {
        button.isEnabled = false
        imageView.isUserInteractionEnabled = false
        guard let name = firstName, name != "",
            let lastName = lastName, lastName != "",
            let dob = dob, dob != "",
            let gender = gender, gender != ""
            else { return }
        let dbMembersRef = Database.members.child(Store.user.familyId).childByAutoId()
        let storageImageRef = Database.storageProfile.child(dbMembersRef.key)
        guard let uploadData = UIImageJPEGRepresentation(imageView.image!, 0.25) else { return }
        storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print (error?.localizedDescription ?? "Error in saveButtonTapped in AddMembersViewController.swift" )
                return
            }
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            let member = Member(profileImage: profileImageUrl, firstName: name, lastName: lastName, gender: gender, birthday: dob, bloodType: "", height: "", weight: "", allergies: "", id: dbMembersRef.key)
            dbMembersRef.setValue(member.serialize(), withCompletionBlock: { error, dataRef in
                button.isEnabled = false
            })
        })
        controller.dismiss(animated: true, completion: nil)
    }

    static func deleteMember(button: UIButton, controller: UIViewController) {
        button.isEnabled = false
        // Alert Controller
        let alertController = UIAlertController(title: "Are you sure you want to delete this member?",  message: "This action cannot be undone.", preferredStyle: .alert)
        // Action
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            let memberRef = Database.members.child(Store.user.familyId)
            let eventsRef = Database.events.child(Store.member.id)
            let postsRef = Database.posts
            var posts = [Post]()
            // Remove members and related events
            var eventIDs = [String]()
            eventsRef.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    let event = Event(snapshot: child as! FIRDataSnapshot)
                    let eventID = event.uniqueID
                    eventIDs.append(eventID)
                }
                for eventID in eventIDs {
                    deletePostImagesFromStorage(uniqueID: eventID)
                    postsRef.child(eventID).observeSingleEvent(of: .value, with: { snapshot in
                        let oldPosts = snapshot.value as? [String : Any]
                        guard let allKeys = oldPosts?.keys else { return }
                        for key in allKeys {
                            let dictionary = oldPosts?[key] as! [String : Any]
                            let post = Post(dictionary: dictionary)
                            posts.append(post)
                        }
                    })
                    for post in posts {
                        switch post {
                        case .photo(_):
                            deletePostImagesFromStorage(uniqueID: post.description)
                        default:
                            break
                        }
                    }
                    postsRef.child(eventID).removeValue()
                    // All posts under event erased
                }
                // Delete events associated with the member
                eventsRef.removeValue()
                // Delete the member from storage
                deleteProfileImagesFromStorage()
                // Delete the member from database
                memberRef.child(Store.member.id).removeValue()
                let _ = controller.navigationController?.popToRootViewController(animated: true)
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // Present the controller
        controller.present(alertController, animated: true, completion: nil)
    }

    static func deletePostImagesFromStorage(uniqueID: String) {
        Database.storagePosts.child(uniqueID).delete { error -> Void in
            if error != nil {
                print("******* Error occured while deleting post imgs from Firebase storage ******** \(uniqueID)")
            } else {
                print("Post image removed from Firebase successfully! \(uniqueID)")
            }
        }
    }

    static func deleteProfileImagesFromStorage() {
        Database.storageProfile.child(Store.member.id).delete { error -> Void in
            if error != nil {
                print("******* Error occured while deleting profile imgs from Firebase storage ******** \(Store.member.id)")
            } else {
                print("profile img removed successfully from the associated member")
            }
        }
    }

    static func updateFirebaseValues(firstName: UITextField,
                                     lastName: UITextField,
                                     dob: UITextField,
                                     gender: UITextField,
                                     height: UITextField,
                                     weight: UITextField,
                                     blood: UITextField,
                                     profilePicture: UIImageView,
                                     allergies: UITextField,
                                     controller: UIViewController) {
        guard let firstName = firstName.text, firstName != "",
            let lastName = lastName.text, lastName != "",
            let dob = dob.text, dob != "",
            let gender = gender.text, gender != "",
            let height = height.text,
            let weight = weight.text,
            let blood = blood.text,
            let profilePicture = profilePicture.image,
            let allergies = allergies.text else { return }

        let memberReference = Database.members.child(Store.user.familyId).child(Store.member.id)
        let databaseMembersRef = Database.members.child(Store.user.familyId).childByAutoId()
        let uniqueID = databaseMembersRef.key
        let imageId = uniqueID
        let storageImageRef = Database.storageProfile.child(imageId)

        if let uploadData = UIImageJPEGRepresentation(profilePicture, 0.25) {
            storageImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print (error?.localizedDescription ?? "Error in saveButtonTapped in EditMembersViewController.swift" )
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                let updatedInfo: [String : Any] = ["firstName":firstName,
                                                   "lastName": lastName,
                                                   "birthday": dob,
                                                   "gender": gender,
                                                   "profileImage": profileImageUrl,
                                                   "bloodType": blood,
                                                   "height": height,
                                                   "weight": weight,
                                                   "allergies": allergies]

                memberReference.updateChildValues(updatedInfo)

                let _ = controller.navigationController?.popViewController(animated: true)
            })
        }
    }
}

