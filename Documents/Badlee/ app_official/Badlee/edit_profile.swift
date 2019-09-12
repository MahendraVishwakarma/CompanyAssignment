//
//  edit_profile.swift
//  Badlee
//  Created by Mahendra on 07/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
// mahendra working here again :)

import UIKit
import SRCountdownTimer

class edit_profile: UIViewController,TrendingProductsCustomDelegate,shareDataDelagate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var loginview: UIView!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var thumb_lbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var lblFirstName: UITextField!
    @IBOutlet weak var lblinterest: UILabel!
    @IBOutlet weak var progressView: SRCountdownTimer!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnHe: UIButton!
    @IBOutlet weak var btnZe: UIButton!
    @IBOutlet weak var btnShe: UIButton!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var lblLastName: UITextField!
    var userInfo:NSDictionary!
    let user_info = appDel.object_user_info
    var gender:String!
    var user_name:String!
    var isUsernameAvail:Bool!
    var param = NSMutableDictionary()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        progressView.isHidden = true
    
        activity.stopAnimating()
        thumb_lbl.isHidden = true
        
        self.setDefaultUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        img_profile.layer.cornerRadius = img_profile.frame.height/2
        img_profile.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func setDefaultUserInfo()
    {
        print(userInfo)
        
        lblFirstName.text = userInfo.object(forKey: "fname") as? String
        lblLastName.text = userInfo.object(forKey: "lname") as? String
        txtDOB.text = userInfo.object(forKey: "dob") as? String
        let str_url =  (userInfo.object(forKey: "avatar") as? String ?? "")
        let url = URL.init(string: (StaticURLs.base_url + str_url))
        if(url != nil)
        {
           img_profile.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        
        img_profile.layer.borderColor = UIColor.gray.cgColor
        img_profile.layer.borderWidth = 0.5
        self.isUsernameAvail = true
        user_info.birthday = userInfo.object(forKey: "dob") as? String
        user_info.first_name = userInfo.object(forKey: "fname") as? String
        user_info.last_name = userInfo.object(forKey: "lname") as? String
        user_info.avatar_link = str_url
        txtusername.text = userInfo.object(forKey: "username") as? String ?? ""
        user_name = userInfo.object(forKey: "username") as? String ?? ""
        user_info.username = userInfo.object(forKey: "username") as? String ?? ""
        
        gender = userInfo.object(forKey: "gender") as? String
        
        let interests = userInfo.object(forKey: "interests") as? String ?? ""
        
            let total_interest = comman.getCategoryName(ids: interests)
           // btnInterest.setTitle(total_interest, for: .normal)
            lblinterest.text = total_interest
            user_info.interested = interests
        
        let str_location = comman.getCityName(name: userInfo.object(forKey: "location") as? String ?? "")
        
        btnLocation.setTitle(str_location, for: .normal)
        user_info.city_id = userInfo.object(forKey: "location") as? String
        
        if(gender == "He")
        {
            btnHe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
            btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            gender = "He"
            
            user_info.gender = gender

        }
        else if(gender == "She")
        {
            btnShe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
            btnHe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            gender = "She"
            user_info.gender = gender
        }
        else if(gender == "Ze")
        {
            btnZe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
            btnHe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
            gender = "Ze"
            user_info.gender = gender
        }
        
        
    }
    
    @IBAction func btnProfile_Pic(_ sender: Any)
    {
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
    func upload_image(uploading_image:UIImage)
    {
        progressView.isHidden = false
        progressView.start(beginingValue: 15, interval: 1)
        
        web_services.upload_image(page_url: "media.php", uploading_image: uploading_image, username: appDel.loginUserInfo.username, password: appDel.loginUserInfo.password, success: { (data) in
            
            DispatchQueue.main.async
                {
                    
                    self.img_profile.image = uploading_image
                    //self.progressView.isHidden = true
                    self.user_info.avatar_link = (data as! NSDictionary).object(forKey: "url") as? String
            }
            
            
        }) { (data) in
            
            
        }
        
    }
    
    
    @IBAction func btnHe(_ sender: Any)
    {
        btnHe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "He"
        user_info.gender = gender
    }
    
    @IBAction func btnSHe(_ sender: Any)
    {
        btnShe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnHe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "She"
        user_info.gender = gender
    }
    
    @IBAction func btnZE(_ sender: Any)
    {
        btnZe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnHe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "Ze"
        user_info.gender = gender
    }
    
    @IBAction func btnInterest(_ sender: UIButton)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "interested_catogories") as! interested_catogories
        object.customDelegateForDataReturn = self
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        object.modalPresentationStyle = .custom
        
        object.selected_row = NSMutableArray()
        let arr = user_info.interested!.components(separatedBy: ",")
        
        var arr_int = Array<Any>()
        
        for  item in arr
        {
            let ids = Int(item)
            if(ids != nil)
            {
                arr_int.append(ids!)
            }
            
        }
        object.selected_row.addObjects(from: arr_int)

        self.present(object, animated: true, completion: nil)
    }
    @IBAction func btnLocation(_ sender: UIButton)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "citiesVC") as! citiesVC
        object.shareDataDelegate = self
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        object.selected_city_id = user_info.city_id
        self.present(object, animated: true, completion: nil)
    }
    func sendData(data: String?, city_id: String?)
    {
        btnLocation.setTitle(data, for: .normal)
        user_info.city = data
        user_info.city_id = city_id
        
    }
    
    func checkout(username:String)
    {
        // let count_username : Int = (username.utf8CString.count)
        
        user_info.username = username
        if(Int(username.count) >= 3)
        {
           
            
            
        }
        else
        {
           
        }
        
    }
    

    func update_api()
    {
        
        user_info.birthday = txtDOB.text
        user_info.username = txtusername.text
        user_info.first_name = lblFirstName.text
        user_info.last_name = lblLastName.text
       // user_info.interested = btnInterest.titleLabel?.text
        
        if(comman.checkusername(username: user_info.username!) == false)
        {
            comman.showAlert("Badlee", "Please enter valid username(a-z ,A-Z , _ ,.)", self)
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
        
    
        let dob = count_birthday > 0 ? user_info.birthday: nil
        let avatar_link = count_link > 0 ? user_info.avatar_link: nil
        
        if(appDel.loginUserInfo.username != user_info.username)
        {
            param.setValue(user_info.username, forKey: "username")
        }
        
        if(appDel.loginUserInfo.last_name != user_info.last_name)
        {
            
             param.setValue(user_info.last_name, forKey: "lname")
        }
        
        if(appDel.loginUserInfo.first_name != user_info.first_name)
        {
            param.setValue(user_info.first_name, forKey: "fname")
        }
        
       if(appDel.loginUserInfo.city_id != user_info.city_id)
       {
          param.setValue(user_info.city_id, forKey: "location")
       }
        if(appDel.loginUserInfo.gender != user_info.gender)
        {
            param.setValue(user_info.gender, forKey: "gender")
        }
        if(user_info.interested != nil)
        {
            param.setValue(user_info.interested, forKey: "interests")
        }
        if(appDel.loginUserInfo.birthday != dob)
        {
            param.setValue(dob, forKey: "dob")
        }
       
        
        self.view.endEditing(true)
        
        param.setValue(app_id, forKey: "application_id")
        param.setValue(app_secret_key, forKey: "application_secret")
        param.setValue(avatar_link, forKey: "avatar")
        
        comman.showLoader(toView: self)
        
        web_services.badlee_postitem_with_param(param: param, page_url: "userupdate.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            comman.hideLoader(toView: self)
            
            let dict :NSDictionary = ["user_id": (data as! NSDictionary).object(forKey: "user_id") as Any,"user_name":(data as! NSDictionary).object(forKey: "username") as Any,"isLogin": 1,"first_name":(data as! NSDictionary).object(forKey: "fname") as Any,"last_name":(data as! NSDictionary).object(forKey: "lname") as Any,"gender":(data as! NSDictionary).object(forKey: "gender") as Any,"birthday":(data as! NSDictionary).object(forKey: "dob") as Any,"city_id":(data as! NSDictionary).object(forKey: "location") as Any,"interested":(data as! NSDictionary).object(forKey: "interests") as Any,"email":(data as! NSDictionary).object(forKey: "email") as Any,"password":appDel.loginUserInfo.password!,"uid": appDel.loginUserInfo.GGHTYLO4567WWERT!]
            
            loginManager.setUserLogin(dict: dict)
            appDel.setUserDefaultData(data: dict)
            
            comman.showAlert("👍", "Great! your profile has been updated", self)
            
            
        }) { (error) in
            
            comman.hideLoader(toView: self)
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        thumb_lbl.isHidden = true
        
        if(textField.tag == 3)
        {
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            
            let object = strbrd.instantiateViewController(withIdentifier: "datepicker") as! datepicker
            object.modalPresentationStyle = .overFullScreen
            object.customDelegateForDataReturn = self
            object.selected_date = txtDOB.text
            object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.present(object, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField.tag == 111)
        {
            if let text = textField.text as NSString? {
                let username = text.replacingCharacters(in: range, with: string)
                if(Int(username.count) >= 3)
                {
                    self.update_userID(username: username)
                }
                else
                {
                    
                    self.thumb_lbl.isHidden = true
                }
                
                self.checkout(username: username)
            }
           
        }
        
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.tag == 111)
        {
            textField.resignFirstResponder()
            self.update_userID(username:textField.text!)
        }
        
        return true
    }
    
    
    
    
    @IBAction func btnUpdate(_ sender: Any)
    {
        if(isUsernameAvail)
        {
             self.update_api()
        }
       
    }
    
    
    func sendDataBackToHomePageViewController(data: String?, data2:String)
    {
        let decimalCharacters = CharacterSet.decimalDigits
        
        let decimalRange = data?.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange != nil {
            txtDOB.text = data
            
        }
        else
        {
            //userInfo.setValue(data2, forKey: "interests")
            user_info.interested = data2
            //btnInterest.setTitle(data, for: .normal)
            lblinterest.text = data
        }
        
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        
    }
    
    func update_userID(username:String)
    {
         self.thumb_lbl.isHidden = false
        
        if(username == user_name)
        {
            self.thumb_lbl.isHidden = false
            self.activity.stopAnimating()
            self.thumb_lbl.text = "👍"
            self.isUsernameAvail = true
            return
        }
        
        if(comman.checkusername(username: username) == false)
        {
            comman.showAlert("Badlee", "Please enter valid username(a-z ,A-Z , _ ,.)", self)
            return
        }
        
        activity.startAnimating()
       
        
        web_services.badlee_get(page_url: "user.php?username=\(username)", isFuckingKey: true, success: { (data) in
            
           
            self.isUsernameAvail = false
            self.thumb_lbl.isHidden = false
            self.activity.stopAnimating()
            self.thumb_lbl.text = "👎"
            self.checkout(username: "")
            
          
            
        }) { (error) in
            
            if((self.txtusername.text?.count)! > 0)
            {
                 self.thumb_lbl.isHidden = false
            }
            else
            {
                 self.thumb_lbl.isHidden = true
            }
           
            self.activity.stopAnimating()
            self.thumb_lbl.text = "👍"
            self.isUsernameAvail = true
            self.checkout(username: username)
           
        }
    }
}
