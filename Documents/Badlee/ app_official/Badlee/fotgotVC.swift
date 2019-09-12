//
//  fotgotVC.swift
//  Badlee
//
//  Created by Mahendra on 26/01/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class fotgotVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.borderColor = UIColor.init(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1).cgColor

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSubmit(_ sender: Any)
    {
        let email = txtEmail.text?.trimmingCharacters(in: .whitespaces)
        
        txtEmail.resignFirstResponder()
        
        let countChar : Int = (txtEmail.text?.count)!
        if(countChar <= 0)
        {
            comman.showAlert("Badlee", "Please enter email id", self)
            return
        }
        
        if(comman.checkEmail(email!, self) == false)
        {
             comman.showAlert("Badlee", "Please enter a valid email id", self)
            return
        }
        
        
        comman.showLoader(toView: self)
        web_services.badlee_post_with_SecretKey(page_url: "forgetpass.php", par: ["email":email as Any], succuss: { (data) in
            comman.hideLoader(toView: self)
             comman.showAlert("Badlee", data?.object(forKey: "response") as! String, self)
            
        }) { (data) in
           comman.hideLoader(toView: self)
            comman.showAlert("Badlee", "something went wrong", self)
        }
       
        
    }
    
    @IBAction func btnBACK(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}
