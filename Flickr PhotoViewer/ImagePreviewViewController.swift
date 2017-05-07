//
//  ImagePreviewViewController.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import Photos

class ImagePreviewViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    //Var
    //Get the URL which needs to be shown
    var getURL : URL?
    //Get image instance
    var image : UIImage? = nil
    
    //MARK: View Loadings
    override func viewDidLoad() {
        
        
        //Sets Image on
        if let URL = self.getURL  {
            self.activityIndicator.startAnimating()
            self.imageView.setImage(withUrl: URL, placeholder: nil, crossFadePlaceholder: false, cacheScaled: false, completion: { (image, error) in
                self.activityIndicator.stopAnimating()
                if error == nil{
                    self.image = image?.image
                    
                }
                else{
                    guard let error = error else{
                        
                        return
                    }
                    Util.showAlert(sender: self, title: "Error", message: error.localizedDescription)
                    
                }
                
            })
        }
        
    }
    
    //MARK: Actions
    //Save image to user device
    @IBAction func savePictureToDevice(_ sender: UIBarButtonItem){
        
        if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .notDetermined{
            Util.showAlert(sender: self, title: "Permission Denied", message: "You might have previously denied the permission. Please go to Settings and Allow Photos permission for the app.")
            
        }
        else{
            if let saveImage = self.image{
                DispatchQueue.main.async(execute: {
                    PHPhotoLibrary.shared().performChanges({
                        
                        PHAssetChangeRequest.creationRequestForAsset(from: saveImage)
                    }) { (success, error) in
                        if success{
                            
                            Util.showAlert(sender: self, title: "Success", message: "Image has been successfully saved.")
                            
                        }
                        else{
                            Util.showAlert(sender: self, title:"Error", message: "Unable to save image at the moment.")
                            
                        }
                        
                    }
                    
                    
                })
            }
            
            
        }
    }
    
    //Closes the ViewController
    @IBAction func closeController(_ sender: UIBarButtonItem){
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
      
}
