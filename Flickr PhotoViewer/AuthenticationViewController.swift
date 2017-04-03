//
//  AuthenticationViewController.swift
//  Flickr PhotoViewer
//
//  Created by Aaqib Hussain on 1/4/17.
//  Copyright © 2017 Aaqib Hussain. All rights reserved.
//

import UIKit
import FlickrKit
import Toast

class AuthenticationViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var webView: UIWebView!
    
    var flickrHelper : FlickrHelper?
    
    
    
    
    //MARK: View Loading Functions
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.auth()
        
    }
    
    
    //MARK: Webview Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.view.hideToastActivity()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        let url = request.url
        
        let scheme = url?.scheme
        //If URL scheme matches then try to do the Auth process
        if "flickrphotoviewer" == scheme{
            if let token = url{
                
                
                User.shared().saveAccessToken(url: token)
                self.flickrHelper = FlickrHelper()
                self.flickrHelper?.checkAuthentication(callBackURL: token, sender: self, { () -> Void? in
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }//else navigate to login
        else if url?.absoluteString == "https://m.flickr.com/#/home" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
        }
        return true
        
    }
    
    //MARK: Functions
    //For calling the Flickr in webview
    private func auth(){
        self.view.makeToastActivity(CSToastPositionCenter)
        let callbackURLString = "flickrPhotoViewer://auth"
        let url = URL(string: callbackURLString)
        FlickrKit.shared().beginAuth(withCallbackURL: url!, permission: FKPermission.delete, completion: { (url, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if ((error == nil)) {
                    let urlRequest = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30)
                    self.webView.loadRequest(urlRequest as URLRequest)
                } else {
                    self.view.hideToastActivity()
                    guard let message = error?.localizedDescription else{
                        return
                    }
                    
                    Util.showAlert(sender: self, title: "Error", message: message)
                    
                }
            });
        })
        
    }
    
}
