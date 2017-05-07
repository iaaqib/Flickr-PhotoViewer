//
//  ProfileViewController.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import Toast
import FlickrKit

class ProfileViewController: UIViewController{
    
    //MARK: Outlets
    @IBOutlet weak var collectionView : UICollectionView!
    //Labels
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var userName : UILabel!
    //Vars
    //For holding the fetched URLs
    var photoURLs : [URL?]?
    //Holds the selected Index
    var selectedCell : Int!
    
    
    //MARK: View Loadings
    override func viewDidLoad() {
        
        if let name = User.shared().name, let userName = User.shared().userName{
            
            self.name.text = "Welcome\n\(name)!"
            self.userName.text = userName
        }
        //Full Down Refresher
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.fetchImages), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        self.fetchImages()
    }
    
    //MARK: Action
    @IBAction func logOut(_ sender : UIBarButtonItem){
        
        self.showConfirmationAlert()
        
    }
    
    //MARK: Functions
    //Fetches images from user profile through Model Object
    func fetchImages(){
        self.view.makeToastActivity(CSToastPositionCenter)
        ProfileModel.getPhotos(sender: self) { (urls, error) in
            self.view.hideToastActivity()
            if error == nil{
                
                guard let URLs = urls else {
                    
                    return
                }
                if URLs.count == 0{
                    
                    Util.showAlert(sender: self, title: "Sorry", message: "No Photos found on your Flickr.")
                    
                }
                else{
                    self.photoURLs = [URL]()
                    self.photoURLs = URLs
                    self.collectionView.reloadData()
                }
                
            }
            else{
                guard let errorMessage = error else {
                    return
                }
                Util.showAlert(sender: self, title: "Error", message: errorMessage.localizedDescription)
                
                
            }
        }
    }
    
    //Confirmation Alert appears when user clicks Logout button
    func showConfirmationAlert(){
        
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.logOut()
        }
        alert.addAction(noButton)
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    //LogOut from App
    func logOut(){
        if(FlickrKit.shared().isAuthorized) {
            FlickrKit.shared().logout()
            
            User.destroy()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
    
    //MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile"{
            let destination = segue.destination as! ImagePreviewViewController
            destination.getURL = self.photoURLs?[self.selectedCell]
            
        }
    }
    
    
}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collecion View DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        cell.photoURL = self.photoURLs?[indexPath.item]
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = self.photoURLs else{
            
            return 0
        }
        return photos.count
    }
    
    //MARK: Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        
        self.performSegue(withIdentifier: "Profile", sender: nil)
    }
    
    //MARK: Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Util.bounds.width / 3
        return CGSize(width: width - 1, height: width - 1)
    }
    
    
}
