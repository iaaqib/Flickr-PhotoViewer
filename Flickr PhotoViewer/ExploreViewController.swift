//
//  ExploreViewController.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 2/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import Toast

class ExploreViewController: UIViewController{
    
    //MARK: Outlets
    @IBOutlet weak var collectionView : UICollectionView!
    
    //Vars
    //For holding the fetched URLs
    var photoURLs : [URL?]?
    //Holds the selected Index
    var selectedCell : Int!
    
    //MARK: View Loadings
    override func viewDidLoad() {
        
        //Pull down Refresher
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.fetchImages), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        self.fetchImages()
    }
    //MARK: Functions
    //Fetches images from Interestingness through Model Object
    func fetchImages(){
        self.view.makeToastActivity(CSToastPositionCenter)
        ExploreModel.getExplore(sender: self) { (urls, error) in
            self.view.hideToastActivity()
            if error == nil{
                
                guard let URLs = urls else {
                    
                    return
                }
                
                self.photoURLs = [URL]()
                self.photoURLs = URLs
                self.collectionView.reloadData()
                
                
            }
            else{
                guard let errorMessage = error else {
                    return
                }
                
                Util.showAlert(sender: self, title: "Error", message: errorMessage.localizedDescription)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Explore"{
            let destination = segue.destination as! ImagePreviewViewController
            destination.getURL = self.photoURLs?[self.selectedCell]
            
        }
    }
    
    
    
}
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collecion View DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCell.identifier, for: indexPath) as! ExploreCell
        
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
        self.performSegue(withIdentifier: "Explore", sender: nil)
    }
    
    //MARK: Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Util.bounds.width / 3
        return CGSize(width: width - 1, height: width - 1)
    }
    
    
    
}


