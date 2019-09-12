//
//  followers_following.swift
//  Badlee
//
//  Created by Mahendra on 04/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class followers_following: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var btnFindbutton: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var userData = NSArray()
    var filter_user = NSArray()
    var userType:String!
    
    @IBOutlet weak var txt_search: UISearchBar!
    @IBOutlet weak var searchWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        filter_user = userData
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        lblUserType.text = userType
        tableview.tableFooterView = UIView.init(frame: .zero)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
        if(userType == "Follower users")
        {
           
            lblMessage.text = "You have no follower 😲 \n\nFollow someone so that they follow you back"
           // btnFindbutton.isHidden = true
        
        }
        else
        {
            
           // btnFindbutton.isHidden = false
            lblMessage.text = "You are not following anyone! 😲"
        }
        
        if(filter_user.count <= 0)
        {
            tableview.isHidden = true
        }
        else
        {
            tableview.isHidden = false
        }
        
        tableview.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter_user.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lblName = cell.viewWithTag(11) as! UILabel
        let imgProfile = cell.viewWithTag(10) as! UIImageView
        
        let btnAction = cell.viewWithTag(15) as! UIButton
        
        lblName.text = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? " "
        
        let userID =  (filter_user[indexPath.row] as! NSDictionary).object(forKey: "user_id") as? String ?? " "
        
        let url =  URL.init(string: StaticURLs.base_url + ((filter_user[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""))
        
        if(url != nil)
        {
             imgProfile.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        
        btnAction.layer.borderColor = AppColor.themeColor.cgColor
        btnAction.layer.borderWidth = 1
        btnAction.layer.cornerRadius = btnAction.frame.height/2
        btnAction.layer.masksToBounds = true
        btnAction.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        let status = comman.isAdded(user_id: userID)
        btnAction.setTitle(status, for: .normal)
        
        if(status == "ADD")
        {
            btnAction.backgroundColor = UIColor.white
            btnAction.setImage(UIImage.init(named: "community_small"), for: .normal)
            btnAction.setTitleColor(AppColor.themeColor, for: .normal)
        }
        else
        {
            btnAction.backgroundColor = AppColor.themeColor
            btnAction.setTitleColor(UIColor.white, for: .normal)
            btnAction.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let userID = (filter_user[indexPath.row] as! NSDictionary).object(forKey: "user_id") as! String
        let isBlocked = comman.checkPermission(reciever_userID: userID)
        let userObject = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        userObject.isIBlocked = isBlocked
        userObject.userID = userID
        self.present(userObject, animated: true, completion: nil)
       // self.navigationController?.pushViewController(userObject, animated: true)
        
    }
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        
        let cell = sender.superview?.superview as! UITableViewCell
        let index = tableview.indexPath(for: cell)
        
        //print(cell.username.text!)
        
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
    
    @IBOutlet var btnFinfFrineds: [UIStackView]!
    
    
    @IBAction func btnFinfFriends(_ sender: Any)
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
            
            filter_user = userData.filtered(using: filter) as NSArray
        }
        else
        {
            filter_user = userData
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
        
        filter_user = userData
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
