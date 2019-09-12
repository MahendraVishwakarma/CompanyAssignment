//
//  SocialMediaLogin.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 10/09/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import GTMAppAuth

class SocialMediaLogin:NSObject,GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")

        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(aController, animated: true, completion: nil)
        }
        

    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {    // Close OAuth2 authentication window
        viewController?.dismiss(animated: true, completion: nil)
    
    }
    
    // facebook login data
    
    func getFBUserData(){
        if(AccessToken.current != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name,first_name, last_name,email,birthday,gender"]).start(completionHandler: { (connection,result, error) -> Void in
                
                if (error == nil){
                    
                    print(result!)
                   // let accessToken = AccessToken.current?.tokenString
                    let fields = result as? [String:Any]
                    let userID = fields?["id"]
                    let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"

                    
                }
            })
        }
    }

    override init() {
        
    }
    
}
