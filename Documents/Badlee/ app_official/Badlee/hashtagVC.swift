//
//  hashtagVC.swift
//  Badlee
//
//  Created by Mahendra on 29/03/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class hashtagVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableview: UITableView!
    var user_list = NSMutableArray()
    var user_child_list = NSArray()
    var selected_username = ""
    var selected_userID = ""
    var parent_object: commentsVC?
    var parentSingle: singlePage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableview.layer.cornerRadius = 20
        tableview.layer.masksToBounds = true
        
        if(comman.user_info != nil)
        {
           // user_list = (comman.user_info.object(forKey: "follower") as? Array ?? [])!
            //user_list.append((comman.user_info.object(forKey: "") as? Array ?? [])!)
            let total_users = NSMutableArray()
            
            total_users.addObjects(from: comman.user_info.object(forKey: "follower") as? Array ?? [])
            total_users.addObjects(from: comman.user_info.object(forKey: "following") as? Array ?? [])
            
            for i in 0..<total_users.count
            {
                let username = (total_users[i] as! NSDictionary).object(forKey: "username") as? String ?? ""
               
                let resultPredicate = NSPredicate(format: "username BEGINSWITH[cd] %@", username)
                let isFound = user_list.filtered(using: resultPredicate)
                
                if(isFound.count <= 0)
                {
                    user_list.add(total_users[i])
                    print(username)
                }
            }
            
            user_child_list = user_list
            
        }
        else
        {
             self.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        print(self.parent ?? "no value")

        // Do any additional setup after loading the view.
    }
    
    override func didMove(toParentViewController parent: UIViewController?)
    {
      parent_object = parent as? commentsVC
        parentSingle = parent as? singlePage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_child_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblName = cell.viewWithTag(11) as! UILabel
        let lbluserName = cell.viewWithTag(12) as! UILabel
        let img_profile = cell.viewWithTag(10) as! UIImageView
        
        img_profile.layer.cornerRadius = img_profile.frame.height/2
        img_profile.layer.masksToBounds = true
        
      
        
        lblName.text =  (user_child_list[indexPath.row] as! NSDictionary).object(forKey: "name") as? String ?? ""
        lbluserName.text =  (user_child_list[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? ""
        
        let img_placeholder = UIImage.init(named: "user pic 1x")

         let str_url = (user_child_list[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""
        
        let avatar_url = URL.init(string: str_url)
        
        img_profile.image = img_placeholder
        if(avatar_url != nil)
        {
            img_profile.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selected_username = (user_child_list[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? ""
        if(parent_object != nil)
        {
             parent_object?.setup_mention(data: selected_username)
        }
        else
        {
             parentSingle?.setup_mention(data: selected_username)
        }
       
        
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
    
    func searchName(name:String)
    {
        print("search name \(name)")
       
        if(Int(name.count) > 0)
        {
             let resultPredicate = NSPredicate(format: "username contains[cd] %@ or name contains[cd] %@", name, name)
             user_child_list = user_list.filtered(using: resultPredicate) as NSArray
            
        }
        else
        {
            user_child_list = user_list
        }
       
        self.tableview.reloadData()
        
    }
  

}
