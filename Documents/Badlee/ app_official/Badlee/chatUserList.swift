//
//  chatUserList.swift
//  Badlee
//
//  Created by Mahendra on 08/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class chatUserList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, update_userlist
{
    var chat_users = NSMutableArray()
    var filteredArray = NSArray()
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txt_search: UISearchBar!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var searchWidth: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var btnSearch: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:0.5)
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowRadius = 0.6
        chatTableView.tableFooterView = UIView.init(frame: .zero)
        
        btnChat.layer.borderWidth = 0.5
        btnChat.layer.borderColor = AppColor.themeColor.cgColor
        
        network_connectivity.update_delegate = self
        
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        self.getUserList()
        if(network_connectivity.message_delegate != nil)
        {
            network_connectivity.message_delegate.message_arrived()
            
        }
         self.tabBarController?.tabBar.isHidden = false
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    //MARK: - tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let profile_logo = cell.viewWithTag(10) as! UIImageView
        
        profile_logo.layer.cornerRadius = profile_logo.frame.height/2
        profile_logo.layer.masksToBounds = true
        profile_logo.layer.borderColor = UIColor.gray.cgColor
        profile_logo.layer.borderWidth = 0.7
        
        let txtName = cell.viewWithTag(11) as! UILabel
        let txtMessage = cell.viewWithTag(12) as! UILabel
        let txtTime = cell.viewWithTag(13) as! UILabel
        let msg_count = cell.viewWithTag(14) as! UILabel
        
        let timestamp : Int64 = Int64((filteredArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "timestamp") as! Int64)
        let epocTime = TimeInterval(timestamp) / 1000
        let date = Date.init(timeIntervalSince1970: epocTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      //  dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let font_bold =  UIFont.init(name: "Muli-Bold", size: 14)
        let font_light =  UIFont.init(name: "Muli-Light", size: 14)
        
        let r_userID = (filteredArray[indexPath.row] as! NSDictionary).object(forKey: "rChatId") as! String
        let s_userID = (filteredArray[indexPath.row] as! NSDictionary).object(forKey: "sChatId") as! String
        
        var hostID = ""
        
        if(r_userID == appDel.loginUserInfo.user_id!)
        {
            hostID = s_userID
        }
        else
        {
            hostID = r_userID
        }
        let unread_message = DBManager.shared.AllChat_unread(loginID: appDel.loginUserInfo.user_id!, userID: hostID)
        
        web_services.badlee_getUserInfo(page_url: "user.php?userid=\(hostID)&short=true", isFuckingKey: true, success: { (data) in
            
            let strURL = (data as? NSDictionary)?.object(forKey: "avatar") as? String ?? ""
            let name = (data as? NSDictionary)?.object(forKey: "username") as? String ?? ""
            txtName.text = name
            let profile_url  = StaticURLs.base_url + strURL
            
            let avatarURl = URL.init(string: profile_url)
            
            if(avatarURl != nil)
            {
                profile_logo.setImageWith(avatarURl!, placeholderImage: UIImage.init(named: "user pic 1x"))
            }
            
            
        }) { (error) in
            
            //print(error?.localizedDescription)
        }
     
        if(unread_message.count > 0)
        {
            msg_count.text = "\(unread_message.count)"
            msg_count.isHidden = false
            txtMessage.font = font_bold
        }
        else
        {
             msg_count.isHidden = true
             txtMessage.font = font_light
        }
     
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
      
        let strDate = dateFormatter.string(from: date)
        
        let local_date = Date()
        let server_date = dateFormatter.date(from: strDate)
        
        let datetime = comman.timeAndDate(startDate: server_date! as NSDate, endDate: local_date as NSDate, timestamp: timestamp, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
        
        txtMessage.text = (filteredArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "message") as? String ?? ""
        
        let msgType = (filteredArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "msgType") as? String ?? ""
        
        if(msgType == "like")
        {
            txtMessage.text = "👌"
        }
        else if(msgType == "image" || msgType == "post")
        {
           txtMessage.text = "🏞 Image"
        }
        txtTime.text = datetime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // self.performSegue(withIdentifier: "messageSegue", sender: indexPath)
        
        let r_userID = (filteredArray[indexPath.row] as! NSDictionary).object(forKey: "rChatId") as? String ?? ""
        let s_userID = (filteredArray[indexPath.row] as! NSDictionary).object(forKey: "sChatId") as? String ?? ""
        
        var hostID = ""
        
        if(r_userID == appDel.loginUserInfo.user_id!)
        {
            hostID = s_userID
        }
        else
        {
            hostID = r_userID
        }
        let reciever_userID = hostID
        let cell = tableView.cellForRow(at: indexPath)
        let txtName = cell?.viewWithTag(11) as! UILabel
        let profile_logo = cell?.viewWithTag(10) as! UIImageView
        
        self.gotoChatBox(userID: reciever_userID,user_name:txtName.text!,profileImage:profile_logo.image!)
        
    }

    func gotoChatBox(userID:String,user_name:String,profileImage:UIImage)
    {
        let object = storyboard?.instantiateViewController(withIdentifier: "messangerVC") as! messangerVC
        object.reciever_userID = userID
        object.user_name = user_name
        object.profile_image = profileImage
        
        self.present(object, animated: true, completion: nil)
    }
    func getUserList()
    {
        chat_users.removeAllObjects()
        
        let Users = DBManager.shared.getUserList(loginID: appDel.loginUserInfo.user_id!)
        
        
        let arrUsers = NSMutableArray()
        arrUsers.addObjects(from: Users as! [Any])
        
        
        for i in 0..<arrUsers.count
        {
            let r_userID = (arrUsers[i] as! NSDictionary).object(forKey: "rChatId") as? String ?? ""
            let s_userID = (arrUsers[i] as! NSDictionary).object(forKey: "sChatId") as? String ?? ""
        
            var hostID = ""
            
            if(r_userID == appDel.loginUserInfo.user_id!)
            {
                hostID = s_userID
            }
            else
            {
                hostID = r_userID
            }
            
            let username = hostID
            
            let resultPredicate = NSPredicate(format: "rChatId MATCHES %@ OR sChatId MATCHES %@", username,username)
            
            let isFound = chat_users.filtered(using: resultPredicate)
            
            let dict = arrUsers[i] as! NSDictionary
            
            if(isFound.count <= 0)
            {
                chat_users.add(dict)
                print(username)
            }
        }
        
        let sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        chat_users.sort(using: sortDescriptors)
        
        filteredArray = chat_users
        
        if(filteredArray.count > 0)
        {
            self.chatTableView.isHidden = false
        }
        else
        {
            self.chatTableView.isHidden = true
        }
        
        chatTableView.reloadData()
        print(arrUsers)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(Int(searchText.count) > 0)
        {
            let filter = NSPredicate(format: "client_name BEGINSWITH[cd] %@", searchText)
            filteredArray = chat_users.filtered(using: filter) as NSArray
        }
        else
        {
            filteredArray = chat_users
        }
        
        self.chatTableView.reloadData()
        
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
        
        searchWidth.constant = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.4)
        {
            self.btnSearch.isHidden = true
            self.txt_search.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
        
    }
    
    func message_arrived()
    {
        self.getUserList()
    }
    
    @IBAction func btnChatUser(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object  = strbrd.instantiateViewController(withIdentifier: "chatSuggesteduser") as! chatSuggesteduser
        object.paraentObj = self
        self.present(object, animated: true, completion: nil)
    }
    
    
    
}
