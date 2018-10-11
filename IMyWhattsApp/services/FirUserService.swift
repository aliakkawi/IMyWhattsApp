//
//  FirUserService.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 08/09/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirUserService {
    
    static let instance = FirUserService()
    private init(){}
    let userReference: CollectionReference = Firestore.firestore().collection("User")
    
    
    
     func loginUserWithEmailAddress (foremail emailAddress: String, andPassword password: String, completion: @escaping(_ error: Error?)-> Void){
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            
            if error != nil {
                
                completion(error)
            }else {
                
                completion(nil)
            }
        }
    }
    
    func registerUserWithEmailAddress (forEmail email: String, andPassword password: String, firstName: String, lastName: String, country: String,
                                       city: String, phone: String, avatarPicked: Bool, image: UIImage?,  completion: @escaping(_ success: Bool, _ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, registerError) in
            
            if registerError != nil {
                
                completion(false, registerError)
            } else {
                
                if let theUser = user {
                    
                    //now we need to upload the image to firebase storeage.
                    if let theImage = image {
                        
                        var scaledImage: UIImage!
                        if avatarPicked {
                            
                            scaledImage = theImage.scaleImage(newWidth: 100)
                        }else{
                            
                            scaledImage = theImage
                        }
                        
                        if let imageData = UIImageJPEGRepresentation(scaledImage, 0.9) {
                            
                            let imageId = NSUUID().uuidString
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            
                            let storageRef = Storage.storage().reference()
                            let userStorageRef = storageRef.child("profileImages").child(imageId)
                            userStorageRef.putData(imageData, metadata: metadata, completion: { (metadata, errorUploadImage) in
                                
                                if errorUploadImage != nil {
                                    
                                    print("error uploading profile image: \(errorUploadImage!.localizedDescription)")
                                    self.addUserToDB(uid: theUser.user.uid, firstName: firstName, lastName: lastName, emailAddress: email, country: country, city: city, phone: phone, avatarUrl: "", completion: { (error) in
                                        
                                        if error != nil {
                                            
                                            print("error adding new user to db: \(error!.localizedDescription)")
                                            self.deleteCurrentUser(completion: { () in
                                                completion(false, error)
                                            })
                                        } else {
                                            
                                            completion(true, nil)
                                        }
                                    })
                                    
                                }else {
                                    
                                    userStorageRef.downloadURL(completion: { (downloadUrl, error) in
                                        
                                        if let theDownloadUrl = downloadUrl {
                                         
                                            let theDownloadUrlString = theDownloadUrl.absoluteString
                                            
                                            self.addUserToDB(uid: theUser.user.uid, firstName: firstName, lastName: lastName, emailAddress: email, country: country, city: city, phone: phone, avatarUrl: theDownloadUrlString, completion: { (error) in
                                                
                                                if error != nil {
                                                    
                                                    print("error adding new user to db: \(error!.localizedDescription)")
                                                    self.deleteCurrentUser(completion: { () in
                                                        completion(false, error)
                                                    })
                                                } else {
                                                    
                                                    completion(true, nil)
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        }
                        
                    }
                    
                } else {
                    
                    
                    completion(false, nil)
                }
                
            }
        }
    }
    
    
    fileprivate func addUserToDB (uid: String, firstName: String, lastName: String, emailAddress: String, country: String, city: String, phone: String, avatarUrl: String, completion: @escaping(_ error: Error?) -> Void) {
        
        
        let userDict: [String: Any] = [
        
            AppUser.AppUserKey.uid : uid,
            AppUser.AppUserKey.pushId : "",
            AppUser.AppUserKey.createdAt: FieldValue.serverTimestamp(),
            AppUser.AppUserKey.updatedAt: FieldValue.serverTimestamp(),
            AppUser.AppUserKey.email: emailAddress,
            AppUser.AppUserKey.firstname: firstName,
            AppUser.AppUserKey.lastname: lastName,
            AppUser.AppUserKey.avatar: avatarUrl,
            AppUser.AppUserKey.isOnline: true,
            AppUser.AppUserKey.phoneNumber : phone,
            AppUser.AppUserKey.countryCode: "+972",
            AppUser.AppUserKey.country : country,
            AppUser.AppUserKey.city : city,
            AppUser.AppUserKey.contacts: [],
            AppUser.AppUserKey.blockedUsers: [],
            AppUser.AppUserKey.loginMethod : "Email Address",
            
        ]
        
        userReference.document(uid).setData(userDict) { (error) in
            
            if error != nil {
                
                completion(error)
            } else {
                
                completion(nil)
            }
        }
    }
    
    
    fileprivate func deleteCurrentUser (completion: @escaping()-> Void) {
        
        Auth.auth().currentUser?.delete(completion: { (error) in
            
            completion()
            
        })
        
    }
    
    
    func getCurrentUserId ()-> String? {
        
        let currentUser = Auth.auth().currentUser
        if let theCurrentUser = currentUser {
            
            return theCurrentUser.uid
        } else {
            
            return nil
        }
    }
    
    
    func isUserExists()-> Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    
    func generateAvatar(firstName: String, lastName: String, completion: @escaping(_ image: UIImage)-> Void) {
        
        let string = "\(firstName.uppercased().first!)\(lastName.uppercased().first!)"//String(firstName.uppercased().first!) + String(lastName.uppercased().first!)
        print("name: \(string)")
        
        let nameLabel = UILabel()
        nameLabel.frame.size = CGSize(width: 100, height: 100)
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 36.0)
        nameLabel.text = string
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.lightGray
        nameLabel.layer.cornerRadius = 25
        
        // now generate image from label.
        UIGraphicsBeginImageContext(nameLabel.frame.size)
        nameLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(image!)
    }
}
