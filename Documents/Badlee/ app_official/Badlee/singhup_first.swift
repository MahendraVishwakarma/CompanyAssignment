
import UIKit

class singhup_first: UIViewController, UITextFieldDelegate, TrendingProductsCustomDelegate {

    @IBOutlet weak var topConstraight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var txtLast_name: UITextField!
    @IBOutlet weak var btnHE: UIButton!
    @IBOutlet weak var btnShe: UIButton!
    @IBOutlet weak var btnRather: UIButton!
    @IBOutlet weak var btnZe: UIButton!
    @IBOutlet weak var txtFist_name: UITextField!
    
    var gender = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var fname = NSMutableAttributedString()
        var lname = NSMutableAttributedString()
        
        let name = "First name"
        let password_name = "Last name"
        
        let color = comman.hexStringToUIColor(hex:"#c0c0c0")
        
        fname = NSMutableAttributedString(string:name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        fname.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range:NSRange(location:0,length:name.count))
        txtFist_name.attributedPlaceholder = fname
        
        lname = NSMutableAttributedString(string:password_name, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Regular", size: 15.0)!])
        lname.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:NSRange(location:0,length:password_name.count))
        txtLast_name.attributedPlaceholder = lname

        btnNext.isEnabled = false
        
        gender  = "He"
       scrollview.contentSize = CGSize(width:UIScreen.main.bounds.width , height:0)
        
        
        
    }
    
    

    override func viewWillAppear(_ animated: Bool)
    {
        topConstraight.constant = UIScreen.main.bounds.height*0.38
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
       
        self.view.endEditing(true)
        let user_info = appDel.object_user_info
        
        user_info.first_name = txtFist_name.text
        user_info.last_name = txtLast_name.text
        user_info.gender = gender
        
        let count_birthday : Int = (txtBirthday.text?.count)!
        
        if count_birthday > 3 {
            user_info.birthday = txtBirthday.text
        }
        
        
        self.performSegue(withIdentifier: "signup2", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    @IBAction func btnZE(_ sender: UIButton)
    {
        btnZe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnHE.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnRather.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "Ze"
        
        self.checkout(fname:txtFist_name.text!, lname: txtLast_name.text!, gender: gender)
    }
    @IBAction func btnSHE(_ sender: UIButton) {
        btnShe.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnHE.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
         btnRather.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "She"
        
        self.checkout(fname:txtFist_name.text!, lname: txtLast_name.text!, gender: gender)
    }
    @IBAction func btnHE(_ sender: UIButton) {
        btnHE.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnRather.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        gender = "He"
        
        self.checkout(fname:txtFist_name.text!, lname: txtLast_name.text!, gender: gender)
    }
    
    @IBAction func RatherNotSay(_ sender: Any)
    {
        btnHE.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnZe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnShe.setImage(UIImage.init(named: "unSelected_radio"), for: .normal)
        btnRather.setImage(UIImage.init(named: "Selected_radio"), for: .normal)
        gender = "Not Say"
        self.checkout(fname:txtFist_name.text!, lname: txtLast_name.text!, gender: gender)
    }
    @IBAction func btnBack(_ sender: Any)
    {
        let appDel =  UIApplication.shared.delegate as! AppDelegate
        let user_info = appDel.object_user_info
        user_info.birthday = nil
        user_info.city = nil
        user_info.email = nil
        user_info.first_name = nil
        user_info.gender = nil
        user_info.interested = nil
        user_info.last_name = nil
        user_info.password = nil
        user_info.username = nil
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if(textField.tag == 3)
        {
            self.view.endEditing(true)
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            
            let object = strbrd.instantiateViewController(withIdentifier: "datepicker") as! datepicker
            object.modalPresentationStyle = .overFullScreen
            object.customDelegateForDataReturn = self
            object.selected_date = txtBirthday.text
            object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.present(object, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField.tag == 1)
        {
            if let text = textField.text as NSString? {
                let fname = text.replacingCharacters(in: range, with: string)
                self.checkout(fname:fname, lname: txtLast_name.text!, gender: gender)
            }
        }
        else if(textField.tag == 2)
        {
            if let text = textField.text as NSString? {
                let lname = text.replacingCharacters(in: range, with: string)
                self.checkout(fname:txtFist_name.text!, lname: lname, gender: gender)
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
        self.checkout(fname:txtFist_name.text!, lname: txtLast_name.text!, gender: gender)
    }
    
    func checkout(fname:String, lname:String, gender:String)
    {
        let count_email : Int = (fname.utf8CString.count)
        let count_password : Int = (lname.utf8CString.count)
        
        if(count_email > 1 && count_password > 1 )
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
    func sendDataBackToHomePageViewController(data: String?, data2:String)
    {
        txtBirthday.text = data
    }
    
    

}
