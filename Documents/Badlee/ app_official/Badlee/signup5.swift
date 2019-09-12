//
//  signup5.swift
//  Badlee
//
//  Created by Mahendra on 27/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking
import SRCountdownTimer


class signup5: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var view_signup: UIView!
    
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var progressView: SRCountdownTimer!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var topCons: NSLayoutConstraint!
    var image_uploaded: UIImage!
    let appDel =  UIApplication.shared.delegate as! AppDelegate
    var user_info : UserInfo!
    
    var param = NSMutableDictionary()
    
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var fname = NSMutableAttributedString()
        user_info = appDel.object_user_info
        
        let name = "Create a user name"
        activityIndicator.stopAnimating()
        lblEmoji.isHidden = true
        
        let color = comman.hexStringToUIColor(hex:"#c0c0c0")
        
        fname = NSMutableAttributedString(string:name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        fname.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range:NSRange(location:0,length:name.count))
        txtUsername.attributedPlaceholder = fname
        btnSignup.isEnabled = false
        view_signup.layer.shadowColor = UIColor.black.cgColor
        view_signup.layer.shadowOpacity = 0.4
        view_signup.layer.shadowOffset = CGSize(width: 0, height: 1)
        view_signup.layer.shadowRadius = 1.5
        
        self.checkFields()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        topCons.constant = UIScreen.main.bounds.height*0.38
        
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btn_TC(_ sender: Any)
    {
        let object = self.storyboard?.instantiateViewController(withIdentifier: "term_condition") as! term_condition
        self.present(object, animated: true, completion: nil)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)

    }
    
    func signupapi()
    {
        
        if(comman.checkusername(username: user_info.username!) == false)
        {
           comman.showAlert("Badlee", "Please enter valid username(a-z ,A-Z ,0-9, _ ,.)", self)
            return
        }
        
        var count_birthday: Int = 0
        if(user_info.birthday != nil)
        {
            count_birthday = (user_info.birthday!.utf8CString.count)
        }
        var count_link: Int = 0
        if(user_info.avatar_link != nil)
        {
            count_link = (user_info.avatar_link!.utf8CString.count)
        }
       
        if(!web_services.isConnectedToNetwork())
        {
           self.showToast(message: "No internet connection")
           return
        }
        
        let dob = count_birthday > 0 ? user_info.birthday: nil
        let avatar_link = count_link > 0 ? user_info.avatar_link: nil
        
        param.setValue(user_info.username, forKey: "username")
        param.setValue(user_info.first_name, forKey: "fname")
        param.setValue(user_info.last_name, forKey: "lname")
        param.setValue(user_info.email, forKey: "email")
        param.setValue(user_info.password, forKey: "password")//id
        param.setValue(app_id, forKey: "application_id")
        param.setValue(app_secret_key, forKey: "application_secret")
        param.setValue(user_info.city_id, forKey: "location") //
        param.setValue(user_info.interested!, forKey: "interests") //
        param.setValue(user_info.gender, forKey: "gender")
        param.setValue(dob, forKey: "dob")
        param.setValue(avatar_link, forKey: "avatar")
        //source=facebook/google/native
        

        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
       // manager.responseSerializer = AFHTTPResponseSerializer()
        

        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: "http://mri2189.badlee.com/register.php", parameters: param, error: nil)
        //request.allHTTPHeaderFields = headers
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       
        
        comman.showLoader(toView: self)
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in

            if(error != nil)
            {
                comman.hideLoader(toView: self)
               NSLog((error?.localizedDescription)!)
                self.showToast(message: "something went wrong. please try again")
                return
            }
            comman.hideLoader(toView: self)
            self.loginAPI(username: self.user_info.username!, password: self.user_info.password!)
        
    }.resume();
    
        
    }
    
    
    func loginAPI(username:String,password:String)
    {
        let save_userInfo = appDel.loginUserInfo
        save_userInfo.username = username
        save_userInfo.password = password
        
        comman.showLoader(toView: self)
        
        let param = ["token":appDel.deviceToken,"dtype":"ios","application_id":app_id,"application_secret":app_secret_key]
        
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "login.php", username: username, password: password, succuss: { (data) in
            
            let dict :NSDictionary = ["user_id": (data as! NSDictionary).object(forKey: "user_id") as Any,"user_name":(data as! NSDictionary).object(forKey: "username") as Any,"isLogin": 1,"first_name":(data as! NSDictionary).object(forKey: "fname") as Any,"last_name":(data as! NSDictionary).object(forKey: "lname") as Any,"gender":(data as! NSDictionary).object(forKey: "gender") as Any,"birthday":(data as! NSDictionary).object(forKey: "dob") as Any,"city_id":(data as! NSDictionary).object(forKey: "location") as Any,"interested":(data as! NSDictionary).object(forKey: "interests") as Any,"email":(data as! NSDictionary).object(forKey: "email") as Any,"password":password,"uid":(data as! NSDictionary).object(forKey: "uid") as Any]
            
            loginManager.setUserLogin(dict: dict)
            self.appDel.setUserDefaultData(data: dict)
            
            
            comman.hideLoader(toView: self)
            self.performSegue(withIdentifier: "welcome", sender: nil)
            
        }) { (data) in
            
            let dict :NSDictionary = ["user_id": "","user_name":"","isLogin": 0,"first_name":"","last_name":"","gender":"","birthday":"","city_id":"","interested":"","email":""]
            
            loginManager.setUserLogin(dict: dict)
            comman.hideLoader(toView: self)
            comman.showAlert("Badlee", "something went wrong", self)
            
        }
        
    }
    

    @IBAction func btn_select_image(_ sender: Any)
    {
         txtUsername.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
       
        let photo = UIAlertAction(title: "Upload existing photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.chppsePhotoSource(source: "photo")
        })
        let camera = UIAlertAction(title: "Take photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
           self.chppsePhotoSource(source: "camera")
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
           
        })
        
        optionMenu.addAction(photo)
        optionMenu.addAction(camera)
        optionMenu.addAction(cancelAction)
        
      
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func chppsePhotoSource(source:String)
    {
        if(source == "photo")
        {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary;
                picker.allowsEditing = true
                picker.modalPresentationStyle = .overCurrentContext
                self.present(picker, animated: true, completion: nil)
            }
        }
        else
        {
            if(UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera;
                picker.allowsEditing = true
                picker.modalPresentationStyle = .overCurrentContext
                self.present(picker, animated: true, completion: nil)
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let img:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
       
        self.dismiss(animated: true, completion: nil)
        self.upload_image(uploading_image: img)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
          self.dismiss(animated: true, completion: nil)
    }

   
    @IBAction func btnSignup(_ sender: Any)
    {
        
        user_info.username = txtUsername.text
        txtUsername.resignFirstResponder()
        
        
        self.signupapi()
    }
    
    func checkout(username:String)
    {
       // let count_username : Int = (username.utf8CString.count)
       
         user_info.username = username
        if(Int(username.count) >= 3)
        {
            btnSignup.isHighlighted = false
            btnSignup.isEnabled = true
            view_signup.layer.shadowOpacity = 0.4
            
           
        }
        else
        {
            btnSignup.isHighlighted = true
            btnSignup.isEnabled = false
            view_signup.layer.shadowOpacity = 0.4
        }
        
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
    
    func checkFields()
    {
       
        let user_info = appDel.object_user_info
        
        if(user_info.username != nil)
        {
            txtUsername.text = user_info.username
            self.checkout(username: txtUsername.text!)
        }
        
    }
    
    func upload_image(uploading_image:UIImage)
    {
        progressView.start(beginingValue: 15, interval: 1)
    
        web_services.upload_image(page_url: "media.php", uploading_image: uploading_image, username: nil, password: nil, success: { (data) in
            
            DispatchQueue.main.async
                {
                    
                self.btnImage.setImage(uploading_image, for: .normal)
                self.appDel.object_user_info.avatar_link = (data as! NSDictionary).object(forKey: "url") as? String
                    
                }
            
            
        }) { (data) in
            
            
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let object = segue.destination as! welcomeVC
        object.img_profile = btnImage.imageView?.image
    }
   

}




