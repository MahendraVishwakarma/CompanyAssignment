//

//

import UIKit

class suggestUserCell: UITableViewCell
{
    
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var actionbutton: UIButton!
}

class suggestedUser: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{

    @IBOutlet weak var txt_search: UISearchBar!
    @IBOutlet weak var searchWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    var userList = NSArray()
    var filterUser = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.getSuggestedUser()
        comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        tableview.tableFooterView = UIView.init(frame: .zero)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! suggestUserCell
        
       
        cell.actionbutton.layer.borderColor = AppColor.themeColor.cgColor
        cell.actionbutton.layer.borderWidth = 1
        cell.actionbutton.layer.cornerRadius = cell.actionbutton.frame.height/2
        cell.actionbutton.layer.masksToBounds = true
        
         cell.actionbutton.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        
        cell.fullname.text = (filterUser[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? ""
        cell.username.text = ((filterUser[indexPath.row] as! NSDictionary).object(forKey: "First_name") as? String ?? "" ) + " " +  ((filterUser[indexPath.row] as! NSDictionary).object(forKey: "Last_name") as? String ?? "" )
        
        let url =  URL.init(string: StaticURLs.base_url + ((filterUser[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""))
        let userID = (filterUser[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = (filterUser[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
        let isBlocked = comman.checkPermission(reciever_userID: userID)
        
        let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
        let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        userObject.isIBlocked = isBlocked
        userObject.userID = userID
        self.present(userObject, animated: true, completion: nil)
    }
    
    

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSuggestedUser()
    {
        comman.showLoader(toView: self)
        web_services.badlee_get_with_authentication(page_url: "search.php?sp\("")&spp\("")&spc\("")&spl\("")&offset=\(0)&limit=\(20)", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
           self.userList = (data as! NSDictionary).object(forKey: "folks") as? NSArray ?? []
           
            self.filterUser = self.userList
            self.tableview.reloadData()
            comman.hideLoader(toView: self)
           
        }, failure: { (err) in
             comman.hideLoader(toView: self)
            print(err!)
        })
    }

    @IBAction func btnAddAction(_ sender: UIButton)
    {
     
        let cell = sender.superview?.superview as! suggestUserCell
        let index = tableview.indexPath(for: cell)
        
        print(cell.username.text!)
        
        let userID = (filterUser[(index?.row)!] as! NSDictionary).object(forKey: "user_id") as! String
        
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
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(Int(searchText.count) > 0)
        {
            let filter = NSPredicate(format: "username BEGINSWITH[cd] %@ OR First_name BEGINSWITH[cd] %@ OR Last_name BEGINSWITH[cd] %@", searchText,searchText,searchText)
            
            filterUser = userList.filtered(using: filter) as NSArray
        }
        else
        {
            filterUser = userList
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
        
        filterUser = userList
        self.tableview.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
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
