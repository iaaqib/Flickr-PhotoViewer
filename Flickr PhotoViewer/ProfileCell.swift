//
//  ProfileCell.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import MapleBacon

class ProfileCell: UICollectionViewCell {
    
   //Identifier
   static let identifier = "ProfileCell"
  //MARK: Outlets 
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var imageView : UIImageView!
    
    
    var photoURL : URL?{
        
        didSet{
    DispatchQueue.main.async(execute: {
    if let URL = self.photoURL  {
    

        self.activityIndicator.startAnimating()
        self.imageView.setImage(withUrl: URL, placeholder: nil, crossFadePlaceholder: false, cacheScaled: false, completion: { (image, error) in
            
            self.activityIndicator.stopAnimating()
            
            
        })  
  
    
    
        }
            })
        }
            
    }
    
    
    
}
