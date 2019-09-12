//
//  SingupWithSocialMedia.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 09/09/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore

class SingupWithSocialMedia: UIViewController {

    @IBOutlet weak var btnCheck: UIButton!
    var isTCAccspted = false
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    let socialMedia = SocialMediaLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let image = btnCheck.imageView?.image?.withRenderingMode(.alwaysTemplate)
        btnCheck.setImage(image, for: .normal)
        btnCheck.imageView?.tintColor = UIColor.gray
        picView.layer.borderWidth = 3
        picView.layer.borderColor = UIColor.white.cgColor
        
        GIDSignIn.sharedInstance().delegate = socialMedia
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = appDelegate.window?.rootViewController
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if(sender.isSelected)
        {
            sender.setImage(UIImage.init(named: "visibility"), for: .normal)
            sender.isSelected = false
            txtPassword.isSecureTextEntry = false
        }
        else
        {
            sender.setImage(UIImage.init(named: "eye"), for: .normal)
            sender.isSelected = true
            txtPassword.isSecureTextEntry = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheck(_ sender: Any) {
        
        if(isTCAccspted) {
            
            btnCheck.setImage(UIImage(named: "unchecked"), for: .normal)
            isTCAccspted = false
        }else {
            btnCheck.setImage(UIImage(named: "checked"), for: .normal)
            isTCAccspted = true
        }
        
        let image = btnCheck.imageView?.image?.withRenderingMode(.alwaysTemplate)
        btnCheck.setImage(image, for: .normal)
        btnCheck.imageView?.tintColor = UIColor.gray
    }
    @IBAction func btnLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnTermsConditions(_ sender: Any) {
        let object = self.storyboard?.instantiateViewController(withIdentifier: "term_condition") as! term_condition
        self.present(object, animated: true, completion: nil)
    }
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginWitFacebook(_ sender: Any) {
        let manager = LoginManager()
        
        manager.loginBehavior = .browser
        manager.logIn(permissions: [.email , .publicProfile, .userBirthday , .userGender], viewController: self) { (result) in
            
            print(result)
            switch result {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                self.socialMedia.getFBUserData()
            }
        }
    }
    
}
