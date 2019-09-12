



import UIKit

class reactionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var reactions:NSDictionary!
    var arrData:Array<Any>!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnWishes: UIButton!
    @IBOutlet weak var btnlike: UIButton!
    var reaction_type = "wish"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        headerView.layer.masksToBounds = false
        
        menuView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        menuView.layer.shadowOffset = CGSize(width:0.0, height:0.6)
        menuView.layer.shadowOpacity = 1.0
        menuView.layer.shadowRadius = 0.6
        menuView.layer.masksToBounds = false
     print(comman.user_info)

       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(comman.user_info == nil || comman.user_info.count <= 0)
        {
            self.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        arrData = reactions.object(forKey: "likes") as? Array ?? []
        reaction_type = (reactions.object(forKey: "purpose") as? String)!
        
        if(reaction_type == "3")
        {
           btnWishes.setImage(UIImage.init(named: "ihave"), for: .normal)
            btnWishes.setTitle("Have", for: .normal)
        }
        else
        {
            btnWishes.setImage(UIImage.init(named: "wish 1x"), for: .normal)
            btnWishes.setTitle("Wish", for: .normal)
        }
        btnWishes.isSelected = false
        btnlike.isSelected = true
        tableview.reloadData()
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let avatar = cell.viewWithTag(1) as! UIImageView
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.layer.masksToBounds = true
        
        let btnAdded  = cell.viewWithTag(3) as! UIButton
        btnAdded.layer.borderColor = AppColor.themeColor.cgColor
        btnAdded.layer.borderWidth = 1
        btnAdded.layer.cornerRadius = btnAdded.frame.height/2
        btnAdded.layer.masksToBounds = true
        
        btnAdded.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        let name = cell.viewWithTag(2) as! UILabel
        name.text = (arrData[indexPath.row] as! NSDictionary).object(forKey: "username") as? String
        
        let userID = (arrData[indexPath.row] as! NSDictionary).object(forKey: "user_id") as? String
        
        let str_url = StaticURLs.base_url + ((arrData[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? "")
        
        let avatar_url = URL.init(string: str_url)
        
        let img_placeholder = UIImage.init(named: "user pic 1x")
        
        if(avatar_url != nil)
        {
            avatar.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
        else
        {
            avatar.image = img_placeholder
        }
      
        let isLareadyAdded =  comman.isAdded(user_id: userID!)
      
        btnAdded.backgroundColor = UIColor.white
        btnAdded.setTitle(isLareadyAdded, for: .normal)
        
        if(isLareadyAdded == "ADD")
        {
            btnAdded.backgroundColor = UIColor.white
            btnAdded.setImage(UIImage.init(named: "community_small"), for: .normal)
            btnAdded.setTitleColor(AppColor.themeColor, for: .normal)
        }
        else
        {
            btnAdded.backgroundColor = AppColor.themeColor
            btnAdded.setTitleColor(UIColor.white, for: .normal)
            btnAdded.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
        }
        
        if(userID != appDel.loginUserInfo.user_id)
        {
            btnAdded.isHidden = false
        }
        else
        {
            btnAdded.isHidden = true
            btnAdded.setTitle("Me", for: .normal)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userID = (arrData[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
        let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
        let isBlocked = comman.checkPermission(reciever_userID: userID)
        let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        userObject.isIBlocked = isBlocked
        userObject.userID = userID
        self.present(userObject, animated: true, completion: nil)
    }
    
    @IBAction func btnLike(_ sender: Any)
    {
        btnWishes.isSelected = false
        btnlike.isSelected = true
        btnlike.setTitleColor(UIColor.black, for: .normal)
        btnWishes.setTitleColor(UIColor.lightGray, for: .normal)
        arrData = reactions.object(forKey: "likes") as? Array ?? []
        tableview.reloadData()
    }
    
    @IBAction func btnwish(_ sender: Any)
    {
        btnWishes.isSelected = true
        btnlike.isSelected = false
        btnlike.setTitleColor(UIColor.lightGray, for: .normal)
        btnWishes.setTitleColor(UIColor.black, for: .normal)
        
        reaction_type = (reactions.object(forKey: "purpose") as? String)!
        
        if(reaction_type == "3")
        {
           arrData = reactions.object(forKey: "have") as? Array ?? []
        }
        else
        {
           arrData = reactions.object(forKey: "wish") as? Array ?? []
        }
        
        tableview.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    func getUserInfo(userID:String)
    {
        comman.showLoader(toView: self)
        let page_url = "user.php?userid=" + appDel.loginUserInfo.user_id!;        web_services.badlee_post_without_auth(page_url: page_url, succuss: { (data) in
            
            comman.user_info = data as? NSDictionary
            self.tableview.reloadData()
            comman.hideLoader(toView: self)
            
        }) { (data) in
            
            comman.hideLoader(toView: self)
            
        }
        
        
    }
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        
        let cell = sender.superview?.superview as! UITableViewCell
        let index = tableview.indexPath(for: cell)
        
       
        
        let userID = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "user_id") as! String
        
        let page_url = "follow.php?userid=" + userID
        
        if(sender.titleLabel?.text == "ADDED")
        {
            let alert = UIAlertController(title: "Badlee", message: "Do you want to unfollow the user?", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK : UIAlertAction = UIAlertAction(title: "YES", style: .default) { (alt) in
                
                comman.showLoader(toView: self)
                web_services.badlee_delete_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    sender.setTitle("ADD", for: .normal)
                    
                    sender.backgroundColor = UIColor.white
                    sender.setImage(UIImage.init(named: "community_small"), for: .normal)
                    sender.setTitleColor(AppColor.themeColor, for: .normal)
                    comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                    comman.hideLoader(toView: self)
                    
                    
                }, failure: { (data) in
                    comman.hideLoader(toView: self)
                    comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                })
            }
            
            let actionNo : UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { (alt) in
                
            }
            alert.addAction(actionNo)
            alert.addAction(actionOK)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else
        {
            comman.showLoader(toView: self)
            
            web_services.badlee_post_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                sender.setTitle("ADDED", for: .normal)
                
                sender.backgroundColor = AppColor.themeColor
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                comman.hideLoader(toView: self)
            }, failure: { (data) in
                comman.hideLoader(toView: self)
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
            })
        }
        
    }
    
   
    
}
