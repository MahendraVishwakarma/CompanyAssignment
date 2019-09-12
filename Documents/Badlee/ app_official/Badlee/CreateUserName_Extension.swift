//
//  CreateUserName_Extension.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 12/09/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

extension CreateUserName:UITextFieldDelegate{
    func initialSetup() {
        activityIndicator.stopAnimating()
        lblEmoji.isHidden = true
        
        user_info = appDel.object_user_info
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.masksToBounds = true
        
        viewProfile.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        viewProfile.layer.shadowOffset = CGSize(width:0.0, height:0.0)
        viewProfile.layer.shadowOpacity = 2.0
        viewProfile.layer.shadowRadius = 2
        
        viewProfile.layer.cornerRadius = viewProfile.frame.size.height/2
        viewProfile.layer.masksToBounds = true
        
        imgProfile.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        imgProfile.layer.shadowOffset = CGSize(width:0.0, height:0.0)
        imgProfile.layer.shadowOpacity = 2.0
        imgProfile.layer.shadowRadius = 2
        
        view_first.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        view_first.layer.shadowOffset = CGSize(width:0.0, height:0.0)
        view_first.layer.shadowOpacity = 2.0
        view_first.layer.shadowRadius = 2
        
        view_first.layer.cornerRadius = view_first.frame.size.height/2
        view_first.layer.masksToBounds = true
        
        
        if let url = URL.init(string: StaticURLs.base_url + (appDel.object_user_info.avatar_link ?? "")) {
            imgProfile.setImageWith(url, placeholderImage:  UIImage.init(named: "user pic 1x"))
        }else{
            imgProfile.image = UIImage.init(named: "user pic 1x")
        }
        

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if let text = textField.text as NSString? {
            let username = text.replacingCharacters(in: range, with: string)
            if(Int(username.count) >= 3)
            {
                self.update_userID(username: username)
            }
            else
            {
                self.lblEmoji.isHidden = true
            }
            self.checkout(username: username)
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //  self.checkout(username: textField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        // self.update_userID(username: textField.text!)
        return true
    }
    
    func update_userID(username:String)
    {
        
        if(comman.checkusername(username: username) == false)
        {
            comman.showAlert("Badlee", "Please enter valid username(a-z ,A-Z , _ ,.)", self)
            return
        }
        
        activityIndicator.startAnimating()
        
        web_services.badlee_get(page_url: "checkuser.php?username=\(username)", isFuckingKey: false, success: { (data) in
            
            self.lblEmoji.isHidden = false
            self.activityIndicator.stopAnimating()
            self.lblEmoji.text = "👎"
            self.checkout(username: "")
            
        }) { (error) in
            self.lblEmoji.isHidden = false
            self.activityIndicator.stopAnimating()
            self.lblEmoji.text = "👍"
            self.checkout(username: username)
            
        }
        
    }
    
    func checkout(username:String)
    {
        user_info?.username = username
       
    }
}
