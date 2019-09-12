//
//  change_password.swift
//  Badlee
//
//  Created by Mahendra on 06/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class change_password: UIViewController {

    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var lblOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var mainview: UIView!
    
    @IBOutlet weak var topCons: NSLayoutConstraint!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainview.layer.cornerRadius = 16
        mainview.layer.masksToBounds = true
        
        btnCross.layer.cornerRadius = 17.5
        btnCross.layer.masksToBounds = true
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // topCons.constant = UIScreen.main.bounds.height*0.39
       // view.layoutIfNeeded()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let viewT = touches.first?.view
        if(viewT != mainview)
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var btnCross: UIButton!
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnChange_PASSWORD(_ sender: Any)
    {
        if(appDel.loginUserInfo.password == lblOldPassword.text)
        {
            if(txtNewPassword.text == ConfirmPassword.text)
            {
                
                web_services.badlee_change_password(page_url: "passupdate.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, newpassword: txtNewPassword.text!, succuss: { (data) in
                    
                    appDel.loginUserInfo.password = self.txtNewPassword.text!
                    self.showToast(message: "Your password has been chenged")
                    self.dismiss(animated: true, completion: nil)
                    
                }, failure: { (data) in
                    self.showToast(message: "something went wrong")
                    
                })
            }
            else
            {
                 comman.showAlert("Badlee", "Password does not match", self)
            }
        }
        else
        {
            comman.showAlert("Badlee", "Please enter correct old password", self)
        }
        
    }
    

}
