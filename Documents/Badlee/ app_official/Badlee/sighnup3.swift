//

//

import UIKit

class sighnup3: UIViewController,TrendingProductsCustomDelegate
{
    
    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblliner: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnNext.isEnabled = false
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
         self.performSegue(withIdentifier: "singup4", sender: nil)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btn_select_city(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "interested_catogories") as! interested_catogories
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        object.customDelegateForDataReturn = self
        
        
        let user_info = appDel.object_user_info
        
        object.selected_row = NSMutableArray()
        if(user_info.interested == nil)
        {
            user_info.interested = ""
        }
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
    func sendDataBackToHomePageViewController(data: String?, data2:String)
    {
        btnInterest.setTitle("", for: .normal)
        lblliner.text = data
        let user_info = appDel.object_user_info
        user_info.interested = data2
       
        
        self.checkout()
        
    }
    
    func checkout()
    {
        let count_t : Int = (lblliner.text?.utf8CString.count)!
        
        if(count_t > 1)
        {
            btnNext.isHighlighted = false
            btnNext.isEnabled = true
            
        }
    }
    
    func checkFields()
    {
       
        let user_info = appDel.object_user_info
        
        if(user_info.interested != nil)
        {
            let interests = comman.getCategoryName(ids: user_info.interested!)
            
            btnInterest.setTitle("", for: .normal)
            lblliner.text = interests
            btnInterest.isSelected = true
            view.layoutIfNeeded()
            self.checkout()
        }
    }
    
    
    
}
