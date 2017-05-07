//
//  ExploreModel.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import FlickrKit

class ExploreModel: NSObject {
    
    //Returns array of image URLs from Interestingness Section of Flickr
    class func getExplore(sender: UIViewController , completionHandler:@escaping (_ photoURLs: [URL?]?, _ error : NSError?)->Void){
        
        var photoURLs = [URL?]()
        let flickrInteresting = FKFlickrInterestingnessGetList()
        flickrInteresting.per_page = "30"
        FlickrKit.shared().call(flickrInteresting) { (response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {

                    for photoDictionary in photoArray {
                        let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small320 , fromPhotoDictionary: photoDictionary)
                        photoURLs.append(photoURL)
                    }
                    completionHandler(photoURLs,nil)

                } else {
                    // Iterating over specific errors for each service
                    if let error = error as? NSError {
                        Util.showAlert(sender: sender, title: "Error", message: error.localizedDescription)
                        
                        switch error.code {
                        case FKFlickrInterestingnessGetListError.serviceCurrentlyUnavailable.rawValue:
                            break;
                        default:
                            break;
                        }
                        

                         completionHandler(nil,error)
                    }
                }
            })
        }
    
    
    
    
    }
    
    
}
