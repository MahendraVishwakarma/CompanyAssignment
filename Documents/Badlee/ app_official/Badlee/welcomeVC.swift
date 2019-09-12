

import UIKit

class welcomeVC: UIViewController
{
    @IBOutlet weak var welcomeName: UILabel!
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var view_first: UIView!
    var img_profile :UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        welcomeName.text =  "Welcome, \(appDel.object_user_info.first_name ?? "")"
        
        let email_chars:String = appDel.object_user_info.email ?? "".components(separatedBy: "@").first ?? ""
        
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
        
       
        let lastChars = appDel.object_user_info.email ?? "".components(separatedBy: "@").last!
        
        var showed_email = ""
        for char in 0..<email_chars.count
        {
            if(char == 0)
            {
                showed_email = String(email_chars.first!)
                
            }
            else if(char == email_chars.count - 1)
            {
                 showed_email = showed_email + String(email_chars.last!)
            }
            else
            {
                showed_email = showed_email + String("*")
            }
        }
        
        lblEmail.text = "We've mailed you a verification link to your registered e-mail id \(showed_email)@\(String(describing: lastChars))"
       
        
       
        if(appDel.object_user_info.avatar_link != nil)
        {
            
            let url = URL.init(string: StaticURLs.base_url + appDel.object_user_info.avatar_link!)
            if(url != nil)
            {
                imgProfile.image = img_profile
            }
            
        }
        else{
             imgProfile.image = UIImage.init(named: "user pic 1x")
        }
        
    }
    
    @IBAction func btnSelectLocation(_ sender: Any) {
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
       // topCons.constant = UIScreen.main.bounds.height*0.38
       // view.layoutIfNeeded()
    }
    
    @IBAction func btnEnter(_ sender: Any)
    {
        
//        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
//        {
//             appDel.nw_connection.setup_connection(badleeID: appDel.loginUserInfo.GGHTYLO4567WWERT!)
//        }
//
//        self.performSegue(withIdentifier: "tabbar", sender: nil)
        
    }
    
    @IBAction func btnTips(_ sender: Any)
    {
        let storybrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = storybrd.instantiateViewController(withIdentifier: "tipsVC") as! tipsVC
        self.present(object, animated: true, completion: nil)
    }
    
}
