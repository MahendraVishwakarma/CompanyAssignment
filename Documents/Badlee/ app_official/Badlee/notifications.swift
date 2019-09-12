//
//  notifications.swift
//  Badlee
//
//  Created by Mahendra on 11/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class notifications: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    
    var arrData = NSArray()
    @IBOutlet weak var notificationTable: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationTable.tableFooterView = UIView.init(frame: .zero)
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            let tabItem = tabItems[3] as! UITabBarItem
            tabItem.image = UIImage.init(named: "notification_unselected")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getNotification()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notification_type = (arrData[indexPath.row] as! NSDictionary).object(forKey: "type") as? String ?? ""
   
        
        if(notification_type == "wish" || notification_type == "like" || notification_type == "have" || notification_type == "comment" || notification_type == "comment_mention")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_lhwc", for: indexPath)
            
            let userImage = cell.viewWithTag(10) as! UIImageView
            let item_image = cell.viewWithTag(12) as! UIImageView
            let message = cell.viewWithTag(11) as! UILabel
            let btnProfile = cell.viewWithTag(13) as! UIButton
            
            btnProfile.addTarget(self, action: #selector(tapped_username(sender:)), for: .touchUpInside)
            
            userImage.layer.cornerRadius = userImage.frame.height/2
            userImage.layer.masksToBounds = true
            
            item_image.layer.cornerRadius = item_image.frame.height/2
            item_image.layer.masksToBounds = true
            
            var url_user_str = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "avatar") as? String ?? ""
            
             var url_item_str = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "post_info") as! NSDictionary).object(forKey: "media") as? String ?? ""
            
             url_item_str = StaticURLs.base_url + url_item_str
             url_user_str = StaticURLs.base_url +  url_user_str
            
            let url_user = URL.init(string: url_user_str)
            if(url_user != nil)
            {
                userImage.setImageWith(url_user!, placeholderImage: UIImage.init(named: "user pic 1x"))
            }
            else{
                userImage.image = UIImage(named: "Title_icon")
            }
            
            let url_item = URL.init(string: url_item_str)
            if(url_item != nil)
            {
                item_image.setImageWith(url_item!, placeholderImage: UIImage.init(named: "Title_icon"))
            }else{
                item_image.image = UIImage(named: "Title_icon")
            }
            
            
            
               let userName = String(((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "fname") as? String ?? "") + " " + String(((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "lname") as? String ?? "")
            
            
            let str_date = (arrData[indexPath.row] as! NSDictionary).object(forKey: "timestamp") as? String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            
            let local_date = Date()
            let server_date = dateFormatter.date(from: str_date!)!
            
            var timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
            
            timestamp = "\n • " + timestamp
            
            var message_str = ""
            if(notification_type == "like")
            {
                message_str = userName + " liked your post " + timestamp
            }
            else if(notification_type == "wish")
            {
                message_str = userName + " wished for your post " + timestamp
            }
            else if(notification_type == "have")
            {
                 message_str = userName + " have what you want " + timestamp
            }
            else if(notification_type == "comment")
            {
                message_str = userName + " commented on your post " + timestamp
            }
            
            else if(notification_type == "comment_mention")
            {
                 message_str = userName + " mentioned you in a comment " + timestamp
            }
            
            let range = (message_str as NSString).range(of: userName)
            
            let attributedString = NSMutableAttributedString(string:message_str)
            
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: range)
            
            let range1 = (message_str as NSString).range(of: timestamp)
            
          
            
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1) , range: range1)
            
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-Regular", size: 12)! , range: range);
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-SemiBold", size: 12)! , range: range1);
            
           
                 message.attributedText = attributedString
            
            
            
            return cell
        }
        else if(notification_type == "follow")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_follow", for: indexPath)
         
            
            let userImage = cell.viewWithTag(10) as! UIImageView
            let btnAction = cell.viewWithTag(12) as! UIButton
            let message = cell.viewWithTag(11) as! UILabel
            
            userImage.layer.cornerRadius = userImage.frame.height/2
            userImage.layer.masksToBounds = true
            
            btnAction.layer.cornerRadius = 15
            btnAction.layer.borderColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1).cgColor
            btnAction.layer.borderWidth = 1
            btnAction.layer.masksToBounds = true
            
            btnAction.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
            
            
          
            
            let url_user_str = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "avatar") as? String ?? ""
            
            let userID = ((arrData[(indexPath.row)] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "user_id") as? String ?? ""
        
            let status = comman.isAdded(user_id: userID)
            btnAction.setTitle(status, for: .normal)
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
            
            let url_user = URL.init(string: StaticURLs.base_url + url_user_str)
            if(url_user != nil)
            {
                userImage.setImageWith(url_user!, placeholderImage: UIImage.init(named: "user pic 1x"))
            }
            
           

            let userName = String(((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "fname") as? String ?? "") + " " + String(((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "lname") as? String ?? "")
            
            
            let str_date = (arrData[indexPath.row] as! NSDictionary).object(forKey: "timestamp") as? String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            
            let local_date = Date()
            let server_date = dateFormatter.date(from: str_date!)!
            
            var timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
            
            timestamp = "\n • " + timestamp
            
            let message_str =  userName + " added you to community " + timestamp
            
            let range = (message_str as NSString).range(of: userName)
            
            let attributedString = NSMutableAttributedString(string:message_str)
            
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: range)
            
            let range1 = (message_str as NSString).range(of: timestamp)
            
            
            
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1) , range: range1)
            
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-Regular", size: 12)! , range: range);
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-SemiBold", size: 12)! , range: range1);
            
            
            message.attributedText = attributedString
            
            
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_follow", for: indexPath)
            
          //  let item_image = cell.viewWithTag(10) as! UIImageView
          //  let message = cell.viewWithTag(11) as! UILabel
            
            
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification_type = (arrData[indexPath.row] as! NSDictionary).object(forKey: "type") as? String ?? ""
        
        if(notification_type == "wish" || notification_type == "like" || notification_type == "have" || notification_type == "comment" || notification_type == "comment_mention")
        {
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            let post_id = ((arrData[(indexPath.row)] as! NSDictionary).object(forKey: "post_info") as! NSDictionary).object(forKey: "id") as! Int
            let object_itemDescription = strbrd.instantiateViewController(withIdentifier: "singlePage") as! singlePage
            object_itemDescription.post_id = post_id
            
            self.navigationController?.pushViewController(object_itemDescription, animated: true)
        }
        else if(notification_type == "follow")
        {
            let userID = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "user_id") as! String
            let isBlocked = comman.checkPermission(reciever_userID: userID)
            let userObject = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
            userObject.isIBlocked = isBlocked
            userObject.userID = userID
            //self.present(userObject, animated: true, completion: nil)
            self.navigationController?.pushViewController(userObject, animated: true)
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getNotification()
    {
        
        comman.showLoader(toView: self)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:MM:ss"
       // formatter.locale = NSLocale.current
        let timestamp_set = formatter.string(from: date)
    
        var timestamp_get:String = UserDefaults.standard.object(forKey: "timestamp") as? String ?? ""
        if(Int(timestamp_get.count) <= 1)
        {
            let calendar = Calendar.current
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
            timestamp_get = formatter.string(from: twoDaysAgo!)
        }
        UserDefaults.standard.set(timestamp_set, forKey: "timestamp")
        UserDefaults.standard.synchronize()
        
        
        
        let param = ["datetime":"2018-01-08 10:10:10"]
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "notifications.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
          
            self.arrData = data as? NSArray ?? []
            self.notificationTable.reloadData()
            
            if(self.arrData.count > 0)
            {
                self.notificationTable.isHidden = false
            }
            else
            {
                self.notificationTable.isHidden = true
            }
            comman.hideLoader(toView: self)
            
           // UIApplication.shared.applicationIconBadgeNumber = 0
            
        }) { (data) in
            
            if(self.arrData.count > 0)
            {
                self.notificationTable.isHidden = false
            }
            else
            {
                self.notificationTable.isHidden = true
            }
            comman.hideLoader(toView: self)
            print(data!)
        }
        
       
       
    }
    
    @objc func tapped_username(sender:UIButton)
    {
        let cell = sender.superview?.superview as! UITableViewCell
        let index = notificationTable.indexPath(for: cell)
        
        let userID = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "source_user_id") as! String
        let isBlocked = comman.checkPermission(reciever_userID: userID)
        let userObject = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        userObject.isIBlocked = isBlocked
        userObject.userID = userID
        //self.present(userObject, animated: true, completion: nil)
        self.navigationController?.pushViewController(userObject, animated: true)
        
    }
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        let cell = sender.superview?.superview as! UITableViewCell
        let index = notificationTable.indexPath(for: cell)
        
        let userID = ((arrData[(index?.row)!] as! NSDictionary).object(forKey: "source_user_info") as! NSDictionary).object(forKey: "user_id") as! String
        
        let page_url = "follow.php?userid=" + userID
        
        
        if(sender.titleLabel?.text == "ADDED")
        {
            
            let alert = UIAlertController(title: "Badlee", message: "Do you want to unfollow the user?", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK : UIAlertAction = UIAlertAction(title: "YES", style: .default) { (alt) in
                
                comman.showLoader(toView: self)
                web_services.badlee_delete_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    DispatchQueue.main.async {
                        sender.backgroundColor = UIColor.white
                        sender.setTitleColor(AppColor.themeColor, for: .normal)
                        sender.setImage(UIImage.init(named: "community_small"), for: .normal)
                        sender.setTitle("ADD", for: .normal)
                        comman.hideLoader(toView: self)
                    }
                   
                    
                }, failure: { (data) in
                    comman.hideLoader(toView: self)
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
                
                 DispatchQueue.main.async {
                    sender.setTitle("ADDED", for: .normal)
                    sender.backgroundColor = AppColor.themeColor
                    sender.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
                    sender.setTitleColor(UIColor.white, for: .normal)
                    comman.hideLoader(toView: self)
                }
                
               
            }, failure: { (data) in
                comman.hideLoader(toView: self)
            })
        }
        
    }
    
    
    
}
