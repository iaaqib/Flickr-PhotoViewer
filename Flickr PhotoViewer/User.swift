//
//  User.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 1/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit

class User : NSObject{
    
    static private var singleton : User?
    
    var userName : String?
    var name : String?
    var userId : String?
    var accessToken : URL?{
        get{
        
        
           let token = User.userDefaults.url(forKey: User.tokenKey)
           
            return token
            
        }
    

    }
    
    
    //UserDefaults for saving token
    static var userDefaults = UserDefaults()
    //Key for accessing/saving token
    static var tokenKey = "accessToken"
    
    //init
    class func shared() -> User {
        
        
        guard let uwShared = singleton else {
            singleton = User()
            return singleton!
        }
        return uwShared
    }
    //deinit
    class func destroy() {
        self.userDefaults.removeObject(forKey: self.tokenKey)
        singleton = nil
    }
    
    //Sets User data to signleton object
    func getProfileInfo(userName : String?,fullName: String?,userId: String?){
        self.userName = userName
        self.name = fullName
        self.userId = userId
        
    }
    //Saving access token in user defaults
    func saveAccessToken(url: URL){
         let token = User.userDefaults.value(forKey: User.tokenKey) as? URL
        if token == nil{
            
            
            User.userDefaults.set(url, forKey: User.tokenKey)
        }
        
        
    }
    
    
    

    
}

