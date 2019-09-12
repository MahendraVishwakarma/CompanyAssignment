//

//

import UIKit

class signup2: UIViewController, shareDataDelagate
{
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var topCons: NSLayoutConstraint!
    let appDel =  UIApplication.shared.delegate as! AppDelegate
    var user_info:UserInfo!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        user_info = appDel.object_user_info
        btnNext.isEnabled = false
        self.checkFields()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        topCons.constant = UIScreen.main.bounds.height*0.38
        view.layoutIfNeeded()
    }
    
    func checkout()
    {
        let count_t : Int = (btnTitle.titleLabel?.text?.utf8CString.count)!
        
        if(count_t > 1)
        {
            btnNext.isHighlighted = false
            btnNext.isEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
        
        self.performSegue(withIdentifier: "signup3", sender: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCity(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "citiesVC") as! citiesVC
        object.shareDataDelegate = self
        object.selected_city_id = user_info.city_id
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.present(object, animated: true, completion: nil)
    }
    
    func sendData(data: String?, city_id: String?)
    {
        
        btnTitle.setTitle(data, for: .normal)
        user_info.city = data
        user_info.city_id = city_id
        btnTitle.isSelected = true

        self.checkout()

        
    }
    func sendDataBackToHomePageViewController(data: String?)
    {
        
    }
    
    func checkFields()
    {

        let user_info = appDel.object_user_info
        
        if (user_info.city != nil)
        {
            btnTitle.setTitle(user_info.city, for: .normal)
            btnTitle.isSelected = true
            self.checkout()
        }
        
        
        
    }
}
