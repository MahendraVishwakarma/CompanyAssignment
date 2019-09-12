//


import UIKit

class chatSuggesteduser: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    var paraentObj:chatUserList!
    var userList = NSMutableArray()
    var filter_user = NSArray()
    
    @IBOutlet weak var txt_search: UISearchBar!
    @IBOutlet weak var searchWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        tableview.tableFooterView = UIView.init(frame: .zero)
        
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool)
    {
        print(comman.user_info)
        if(comman.user_info != nil)
        {
            let arrFollowing = comman.user_info.object(forKey: "following") as? NSArray ?? []
            let arrFollowers = comman.user_info.object(forKey: "follower") as? NSArray ?? []
            
            let total_users = NSMutableArray()
            
            total_users.addObjects(from: arrFollowers as! [Any])
            total_users.addObjects(from: arrFollowing as! [Any])
            
            
            for i in 0..<total_users.count
            {
                let user_id = (total_users[i] as! NSDictionary).object(forKey: "user_id") as? String ?? ""
                
                let resultPredicate = NSPredicate(format: "user_id MATCHES %@", user_id)
                
                let isFound = userList.filtered(using: resultPredicate)
                
                let dict = total_users[i] as! NSDictionary
                
                if(isFound.count <= 0)
                {
                    userList.add(dict)
                  
                }
                
            }
            
//            if(arrFollowing.count > 0)
//            {
//
//                userList.addObjects(from: arrFollowing as! [Any])
//            }
//
//            if(arrFollowers.count > 0)
//            {
//                userList.addObjects(from: arrFollowers as! [Any])
//            }
            
            filter_user = userList
            
            if(self.filter_user.count <= 0)
            {
                self.tableview.isHidden = true
            }
            else
            {
                self.tableview.isHidden = false
            }
        }
        else
        {
             self.tableview.isHidden = true
        }
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filter_user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! suggestUserCell
        
        
        cell.actionbutton.layer.borderColor = AppColor.themeColor.cgColor
        cell.actionbutton.layer.borderWidth = 1
        cell.actionbutton.layer.cornerRadius = cell.actionbutton.frame.height/2
        cell.actionbutton.layer.masksToBounds = true
        
        cell.actionbutton.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        
        cell.username.text = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? ""
        
        let url =  URL.init(string: StaticURLs.base_url + ((filter_user[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""))
        let userID = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
        let status = comman.isAdded(user_id: userID)
        
        if(status == "ADD")
        {
            cell.actionbutton.backgroundColor = UIColor.white
            cell.actionbutton.setImage(UIImage.init(named: "community_small"), for: .normal)
            cell.actionbutton.setTitleColor(AppColor.themeColor, for: .normal)
        }
        else
        {
            cell.actionbutton.backgroundColor = AppColor.themeColor
            cell.actionbutton.setTitleColor(UIColor.white, for: .normal)
            cell.actionbutton.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
        }
        
        cell.actionbutton.setTitle(status, for: .normal)
        
        if(url != nil)
        {
            cell.profileimg.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let reciever_userID = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
        let reciever_userName = ((filter_user[indexPath.row] as! NSDictionary).object(forKey: "fname") as? String ?? "") + " " + ((filter_user[indexPath.row] as! NSDictionary).object(forKey: "lname") as? String ?? "")
        
        let cell = tableView.cellForRow(at: indexPath) as! suggestUserCell
        
       // let reciever_profileURL = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""
        
       
        self.dismiss(animated: false) {
            self.paraentObj.gotoChatBox(userID: reciever_userID, user_name: reciever_userName, profileImage: cell.profileimg.image!)
        }
    }
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        
        let cell = sender.superview?.superview as! suggestUserCell
        let index = tableview.indexPath(for: cell)
        
        print(cell.username.text!)
        
        let userID = (filter_user[(index?.row)!] as! NSDictionary).object(forKey: "user_id") as! String
        
        let page_url = "follow.php?userid=" + userID
        
        if(sender.titleLabel?.text == "ADDED")
        {
            let alert = UIAlertController(title: "Badlee", message: "Do you want to unfollow the user?", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK : UIAlertAction = UIAlertAction(title: "YES", style: .default) { (alt) in
                
                //   comman.showLoader(toView: self)
                sender.setTitle("ADD", for: .normal)
                
                sender.backgroundColor = UIColor.white
                sender.setImage(UIImage.init(named: "community_small"), for: .normal)
                sender.setTitleColor(AppColor.themeColor, for: .normal)
                
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
            //comman.showLoader(toView: self)
            sender.backgroundColor = AppColor.themeColor
            sender.setTitle("ADDED", for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
            
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
    
    @IBAction func btnFollow(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "suggestedUser") as! suggestedUser
        self.present(object, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(Int(searchText.count) > 0)
        {
            let filter = NSPredicate(format: "username BEGINSWITH[cd] %@ OR name BEGINSWITH[cd] %@", searchText,searchText)
            filter_user = userList.filtered(using: filter) as NSArray 
        }
        else
        {
            filter_user = userList
        }
        
        self.tableview.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchWidth.constant = 65
        searchBar.resignFirstResponder()
        
        UIView.animate(withDuration: 0.4)
        {
            self.btnSearch.isHidden = false
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSearch(_ sender: UIButton)
    {
        
        searchWidth.constant = UIScreen.main.bounds.width - 35
        UIView.animate(withDuration: 0.4)
        {
            self.btnSearch.isHidden = true
            self.txt_search.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
        
    }
    

}
