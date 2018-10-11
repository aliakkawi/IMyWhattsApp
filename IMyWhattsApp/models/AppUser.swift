//
//  AppUser.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 07/09/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AppUser {
    
    public private(set) var uid: String
    public private(set) var pushId: String?
    public private(set) var createdAt: Date!
    public private(set) var updatedAt: Date!
    public private(set) var email: String
    public private(set) var firstname: String
    public private(set) var lastname: String
    public private(set) var fullname: String
    public private(set) var avatar: String
    public private(set) var isOnline: Bool
    public private(set) var phoneNumber: String
    public private(set) var countryCode: String
    public private(set) var country:String
    public private(set) var city: String
    public private(set) var contacts: [String]
    public private(set) var blockedUsers: [String]
    public private(set) var loginMethod: String
    
    
    
    init(uid: String, pushId: String?, email: String, firstname: String, lastname: String, avatar: String, isOnline: Bool, phoneNumber: String, countryCode: String, country:String, city: String, contacts: [String], blockedUsers: [String], loginMethod: String) {
        
        
        self.uid = uid
        self.pushId = pushId
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.fullname = "\(firstname) \(lastname)"
        self.avatar = avatar
        self.isOnline = isOnline
        self.phoneNumber = phoneNumber
        self.countryCode = ""
        self.country = country
        self.city = city
        self.contacts = []
        self.blockedUsers = []
        self.loginMethod = loginMethod
        
    }
    
    enum AppUserKey {
        
        static let uid = "uid"
        static let pushId = "pushId"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let email = "email"
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let fullname = "fullname"
        static let avatar = "avatar"
        static let isOnline = "isOnline"
        static let phoneNumber = "phoneNumber"
        static let countryCode = "countryCode"
        static let country = "country"
        static let city = "city"
        static let contacts = "contacts"
        static let blockedUsers = "blockedUsers"
        static let loginMethod = "loginMethod"
        
    }
    
    class func transformUser(dict: [String: Any]) -> AppUser {
        
        let uid = dict[AppUserKey.uid] as? String ?? ""
        let pushId = dict[AppUserKey.pushId] as? String ?? ""
        
        let createdAtTimestamp: Timestamp = dict[AppUserKey.createdAt] as! Timestamp
        let createdAt = createdAtTimestamp.dateValue()
        
        let updatedAtTimestamp: Timestamp = dict[AppUserKey.updatedAt] as! Timestamp
        let updatedAt = updatedAtTimestamp.dateValue()
        let email = dict[AppUserKey.email] as? String ?? ""
        let firstname = dict[AppUserKey.firstname] as? String ?? ""
        let lastname = dict[AppUserKey.lastname] as? String ?? ""
        //let fullname = dict[AppUserKey.fullname] as? String ?? ""
        let avatar = dict[AppUserKey.avatar] as? String ?? ""
        let isOnline = dict[AppUserKey.isOnline] as? Bool ?? true
        
        let city = dict[AppUserKey.city] as? String ?? ""
        let country = dict[AppUserKey.country] as? String ?? ""
        let loginMethod = dict[AppUserKey.loginMethod] as? String ?? ""
        let phoneNumber = dict[AppUserKey.phoneNumber] as? String ?? ""
        let countryCode = dict[AppUserKey.countryCode] as? String ?? ""
        
        let blockedUsers = dict[AppUserKey.blockedUsers] as? [String] ?? [String]()
        let contacts = dict[AppUserKey.contacts] as? [String] ?? [String]()
        
        
        
        
        let appUser = AppUser(uid: uid, pushId: pushId, email: email, firstname: firstname, lastname: lastname, avatar: avatar, isOnline: isOnline, phoneNumber: phoneNumber, countryCode: countryCode, country: country, city: city, contacts: contacts, blockedUsers: blockedUsers, loginMethod: loginMethod)
        
        appUser.createdAt = createdAt
        appUser.updatedAt = updatedAt
        return appUser
    }
    
    
}
