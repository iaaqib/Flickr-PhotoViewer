//
//  LoginViewController.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 1/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import FlickrKit


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var loginButton: TKTransitionSubmitButton!
    var flickrHelper  = FlickrHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        //If Contains the Access Token, get the user in Profile Screen
        if User.shared().accessToken != nil{
            loginButton.startLoadingAnimation()
            self.flickrHelper.login(sender: self, { (error) -> Void in
                
                self.stopAnimating()
                
                
            })
            
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Stops Animation of button and send User to Profile Screen
    func stopAnimating(){
        
        
        loginButton.animate(duration: 0.8, completion: { () -> () in
            //Your Transition
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            tabBarVC?.transitioningDelegate = self
            self.navigationController?.pushViewController(tabBarVC!, animated: false)
            
            self.loginButton.returnToOriginalState()
            
            
            
        })
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    
    
    
}

