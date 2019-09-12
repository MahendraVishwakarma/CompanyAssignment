

import UIKit
import AFNetworking
import MBProgressHUD
import GoogleSignIn
import FacebookLogin
import FacebookCore


class login: UIViewController,UIGestureRecognizerDelegate
{

    @IBOutlet weak var topCons: NSLayoutConstraint!
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var login_view: UIView!
    @IBOutlet weak var viewContainer: UIView!
   
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserNameField: UITextField!
    @IBOutlet var btnSignup: UIButton!
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var socialView: UIView!
    
    let socialMedia = SocialMediaLogin()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var user_name = NSMutableAttributedString()
        var password = NSMutableAttributedString()
        GIDSignIn.sharedInstance().delegate = socialMedia
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = appDelegate.window?.rootViewController
        let name = "Username/email"
        let password_name = "Password"
        
        let color = comman.hexStringToUIColor(hex:"#c0c0c0")
        
        user_name = NSMutableAttributedString(string:name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        user_name.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range:NSRange(location:0,length:name.count))
        txtUserNameField.attributedPlaceholder = user_name
        
        password = NSMutableAttributedString(string:password_name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        password.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:NSRange(location:0,length:password_name.count))
        txtPassword.attributedPlaceholder = password
    
        login_view.layer.shadowColor = AppColor.themeColor.cgColor
        login_view.layer.shadowOpacity = 0.4
        login_view.layer.shadowOffset = CGSize(width: 1, height: 2)
        login_view.layer.shadowRadius = 2.5
        
//        signupView.layer.shadowColor = AppColor.themeColor.cgColor
//        signupView.layer.shadowOpacity = 0.4
//        signupView.layer.shadowOffset = CGSize(width: 1, height: 2)
//        signupView.layer.shadowRadius = 2.5
        
        socialView.layer.shadowColor = AppColor.themeColor.cgColor
        socialView.layer.shadowOpacity = 0.4
        socialView.layer.shadowOffset = CGSize(width: 1, height: 2)
        socialView.layer.shadowRadius = 2.5
        
       //callAPI()
        
    }
    
    func callAPI() {
        let headers = ["Content-Type" : "application/x-www-form-urlencoded"]
        
      
        let param = NSMutableDictionary()
        param.setValue("mri", forKey: "username")
        param.setValue("dul", forKey: "fname")
        param.setValue("go", forKey: "lname")
        param.setValue("swami@gmail.com", forKey: "email")
        param.setValue("1234567890", forKey: "password")//id
        param.setValue("wemeUlNjMm4s79KzRyjY", forKey: "application_id")
        param.setValue("fkgcdIIPdBg5poWfxfKV", forKey: "application_secret")
       
        param.setValue("He", forKey: "gender")
        param.setValue("10/10/1991", forKey: "dob")
        param.setValue("", forKey: "avatar")
        param.setValue("facebook", forKey: "source")
        
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        // manager.responseSerializer = AFHTTPResponseSerializer()
        
        
        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: "http://mri2189.v1.1.badlee.com/register.php", parameters: param, error: nil)
        //request.allHTTPHeaderFields = headers
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                
                NSLog((error?.localizedDescription)!)
                self.showToast(message: "something went wrong. please try again")
                return
            }
           
            }.resume();
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let object = self.storyboard?.instantiateViewController(withIdentifier: "welcomeVC")
        self.navigationController?.pushViewController(object!, animated: true)
        return
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
    

    @IBAction func btn_login(_ sender: Any) {
        
//        if let object = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserName") {
//            self.navigationController?.pushViewController(object, animated: true)
//        }
//
//
//        return
        
        let username : Int = (txtUserNameField.text?.count)!
        let password : Int = (txtPassword.text?.count)!
        
        if(username <= 0)
        {
            comman.showAlert("Badlee", "Please enter username/email", self)
            return
        }
        
        if(password <= 0)
        {
            comman.showAlert("Badlee", "Please enter password", self)
            return
        }
        
        self.view.endEditing(true)
        self.loginAPI()
       
    }
    
    func handleTap()
    {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loginAPI()
    {
        let save_userInfo = appDel.loginUserInfo
        save_userInfo.username = txtUserNameField.text!
        save_userInfo.password = txtPassword.text!
  
        comman.showLoader(toView: self)
    
        let param = ["token":appDel.deviceToken,"dtype":"ios","application_id":app_id,"application_secret":app_secret_key]
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "login.php", username: txtUserNameField.text!, password: txtPassword.text!, succuss: { (data) in
            
         //   print(data)
            if(data != nil && !(data is NSDictionary))
            {
                let dict :NSDictionary = ["user_id": "","user_name":"","isLogin": 0,"first_name":"","last_name":"","gender":"","birthday":"","city_id":"","interested":"","email":""]
                
                loginManager.setUserLogin(dict: dict)
                comman.hideLoader(toView: self)
                comman.showAlert("Badlee", "something went wrong", self)
            }
            let dict :NSDictionary = ["user_id": (data as! NSDictionary).object(forKey: "user_id") as Any,"user_name":(data as! NSDictionary).object(forKey: "username") as Any,"isLogin": 1,"first_name":(data as! NSDictionary).object(forKey: "fname") as Any,"last_name":(data as! NSDictionary).object(forKey: "lname") as Any,"gender":(data as! NSDictionary).object(forKey: "gender") as Any,"birthday":(data as! NSDictionary).object(forKey: "dob") as Any,"city_id":(data as! NSDictionary).object(forKey: "location") as Any,"interested":(data as! NSDictionary).object(forKey: "interests") as Any,"email":(data as! NSDictionary).object(forKey: "email") as Any,"password":self.txtPassword.text!,"uid":(data as! NSDictionary).object(forKey: "uid") as Any]
            
            loginManager.setUserLogin(dict: dict)
            appDel.setUserDefaultData(data: dict)
            comman.hideLoader(toView: self)
            self.performSegue(withIdentifier: "tabbar", sender: nil)
            
        }) { (data) in
            
            print(data?.localizedDescription ?? "")
            let dict :NSDictionary = ["user_id": "","user_name":"","isLogin": 0,"first_name":"","last_name":"","gender":"","birthday":"","city_id":"","interested":"","email":""]
            
            loginManager.setUserLogin(dict: dict)
            comman.hideLoader(toView: self)
            comman.showAlert("Badlee", "something went wrong", self)
            
        }
        
    }
    
    @IBAction func btnForgot(_ sender: Any)
    {
        let alert = UIAlertController(title: "Forgot password", message: "Enter registered email id to reset password", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email id"
        }
        
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.forgotPassword(email: (textField?.text)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func forgotPassword(email:String)
    {
      
        
        let countChar : Int = (email.count)
        if(countChar <= 0)
        {
            comman.showAlert("Badlee", "Please enter email id", self)
            return
        }
        
        if(comman.checkEmail(email, self) == false)
        {
            comman.showAlert("Badlee", "Please enter a valid email id", self)
            return
        }
        
        
        comman.showLoader(toView: self)
        web_services.badlee_post_with_SecretKey(page_url: "forgetpass.php", par: ["email":email as Any], succuss: { (data) in
            comman.hideLoader(toView: self)
            comman.showAlert("Badlee", data?.object(forKey: "response") as! String, self)
            
        }) { (data) in
            print(data!)
            comman.hideLoader(toView: self)
            comman.showAlert("Badlee", "something went wrong", self)
        }
        
    }
    
    @IBAction func btnSignup(_ sender: Any)
    {
        self.performSegue(withIdentifier: "singupSocialMediaSegue", sender: nil)
    }
    
    @IBAction func showPassword(_ sender: UIButton)
    {
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
    
}
