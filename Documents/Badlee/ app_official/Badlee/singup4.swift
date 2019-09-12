//
//  singup4.swift
//  Badlee
//
//  Created by Mahendra on 27/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class singup4: UIViewController, UITextFieldDelegate
{


    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtEmai: UITextField!
    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    
    var isEmailAvail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fname = NSMutableAttributedString()
        var lname = NSMutableAttributedString()

        let name = "Email Id"
        let password_name = "Create a password"
        
        let color = comman.hexStringToUIColor(hex:"#c0c0c0")
        
        fname = NSMutableAttributedString(string:name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        fname.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range:NSRange(location:0,length:name.count))
        txtEmai.attributedPlaceholder = fname
        
        lname = NSMutableAttributedString(string:password_name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        lname.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:NSRange(location:0,length:password_name.count))
        txtpassword.attributedPlaceholder = lname
        btnNext.isEnabled = false
       
        self.checkFields()

    }
    override func viewWillAppear(_ animated: Bool)
    {
        topCons.constant = UIScreen.main.bounds.height*0.38
        view.layoutIfNeeded()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
        self.view.endEditing(true)
        let appDel =  UIApplication.shared.delegate as! AppDelegate
        let user_info = appDel.object_user_info
        
        if(comman.checkEmail(txtEmai.text!, self) == true)
        {
           user_info.email = txtEmai.text
        }
        else
        {
            self.showToast(message: "Please enter a valid email address")
            return
        }
        
        if(Int(txtpassword.text!.count) < 6)
        {
            self.showToast(message: "Password must be atleast 6 characters")
            return
        }
        
        user_info.password = txtpassword.text
        self.performSegue(withIdentifier: "singup5", sender: nil)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField.tag == 10)
        {
            if let text = textField.text as NSString? {
                let email = text.replacingCharacters(in: range, with: string)
                self.checkout(email: email, password: txtpassword.text!)
                self.checkMail(email: email)
                
            }
        }
        else
        {
            if let text = textField.text as NSString? {
                let password = text.replacingCharacters(in: range, with: string)
                self.checkout(email: txtEmai.text!, password: password )
            }
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
       // self.checkout()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkout(email:String, password:String)
    {
        let count_email : Int = (email.utf8CString.count)
        let count_password : Int = (password.utf8CString.count)
        
        if(count_email > 1 && count_password > 1 && isEmailAvail)
        {
            btnNext.isHighlighted = false
            btnNext.isEnabled = true
        }
        else
        {
            btnNext.isHighlighted = true
            btnNext.isEnabled = false
        }
    }
   
    
    func checkFields()
    {

        let user_info = appDel.object_user_info
       
        
        if(user_info.email != nil)
        {
            txtEmai.text = user_info.email
            
            if(user_info.password != nil)
            {
                self.checkout(email: user_info.email!, password: user_info.password! )
            }
            else
            {
                self.checkout(email: user_info.email!, password: "" )
            }
            
        }
         if(user_info.password != nil)
        {
            txtpassword.text = user_info.password
            if(user_info.email != nil)
            {
                self.checkout(email: user_info.email!, password:user_info.password! )
            }
            else
            {
                self.checkout(email: "", password: user_info.password! )
            }
            
        }
    }
    
    func checkMail(email:String)
    {
        //comman.showLoader(toView: self)
        
        web_services.badlee_get(page_url: "checkuser.php?email=\(email)", isFuckingKey: false, success: { (data) in
            
            print(data!)
            comman.showAlert("Badlee", "This email is already used", self)
            self.isEmailAvail = false
            self.checkout(email: self.txtEmai.text!, password:self.txtpassword.text! )
            
           
        }) { (error) in
            
            print(error?.localizedDescription ?? "")
            self.isEmailAvail = true
            self.checkout(email: self.txtEmai.text!, password:self.txtpassword.text! )
            
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton)
    {
        if(sender.isSelected)
        {
            sender.setImage(UIImage.init(named: "visibility"), for: .normal)
            sender.isSelected = false
            txtpassword.isSecureTextEntry = false
        }
        else
        {
            sender.setImage(UIImage.init(named: "eye"), for: .normal)
            sender.isSelected = true
            txtpassword.isSecureTextEntry = true
        }
    }
    

}
