//
//  ProfileModel.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import FlickrKit

class ProfileModel : NSObject{
    
        //Returns array of image URLs from Profile Section of User
    class func getPhotos(sender: UIViewController , completionHandler:@escaping (_ photoURLs: [URL?]?, _ error : NSError?)->Void){
        var photoURLs = [URL?]()
        if FlickrKit.shared().isAuthorized {
            guard let userId = User.shared().userId else{
                return
            }

            FlickrKit.shared().call("flickr.photos.search", args: ["user_id": userId] , maxCacheAge: FKDUMaxAge.neverCache, completion: { (response, error) -> Void in
                
                if error == nil{
                     DispatchQueue.main.async(execute: { () -> Void in
                    if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                        for photoDictionary in photoArray {
                            let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small320, fromPhotoDictionary: photoDictionary)

                            photoURLs.append(photoURL)
                        }
                        
                        completionHandler(photoURLs,nil)
                    }
                     })
                }
                else{
                    
                    
                    completionHandler(nil,error as? NSError)
                }
                
            })
        } else {
            Util.showAlert(sender: sender, title: "Error", message: "Please Login first.")
            
        }
        
        
        
    }
    
    
    
    
    
}
