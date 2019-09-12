//
//  Followers.swift
//  Badlee
//
//  Created by Mahendra on 30/01/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit


class Followers: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{

    var userList = NSArray()
    var selected_user = NSMutableArray()
    var arrfilteredUsers = NSArray()
    
    
    @IBOutlet weak var bottom_constraight: NSLayoutConstraint!
    @IBOutlet weak var txtField: UITextField!
    var selected_imageURL:String!
    var sender_name :String!
    var item_description:String!
    var item_id:String!
    var item_url:String!
    var item_ownerID:String!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var senderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        txtField.layer.cornerRadius = 10
        txtField.layer.masksToBounds = true
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.leftViewMode = .always
        txtField.leftView = UIView.init(frame: CGRect(x:0,y:0,width:10,height:0))
        tableview.tableFooterView = UIView.init(frame: .zero)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getUserList()
    }
    
    @objc func keyboardWillShow(notification:NSNotification)
    {
        adjustingHeight(show: true, notification: notification)
       // self.refreshData()
    }
    
    @objc func keyboardWillHide(notification:NSNotification)
    {
        adjustingHeight(show: false, notification: notification)
        self.refreshData()
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification)
    {
        
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        print(keyboardFrame.height)
        //print(keyboardFrame1.height)
        
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = (keyboardFrame.height ) * (show ? 1 : 0)
        
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottom_constraight.constant = changeInHeight
            self.view.layoutIfNeeded()
        })
        
        
        
    }
    
    func refreshData()
    {
        DispatchQueue.main.async {
            self.tableview.reloadData()
            let index = NSIndexPath.init(item: self.userList.count - 1, section: 0)
            
            if(index.row <= self.userList.count && index.row >= 0)
            {
                self.tableview.scrollToRow(at: index as IndexPath, at: .bottom, animated: false)
                
                
            }
        }
        
        
        //self.view.layoutIfNeeded()
        // self.view.updateConstraints()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func tappedOnView(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    //MARK: - tableview datasource and delegate
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Suggested friends"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x:0,y:4,width:tableview.frame.width,height:40))
        headerView.backgroundColor = .white
        let lbl = UILabel.init(frame: CGRect(x:20,y:0,width:tableview.frame.width,height:40))
    
        lbl.textColor = UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1)
        lbl.font = UIFont.init(name: "Muli-Regular", size: 17)
        lbl.text = "Suggested friends"
        headerView.addSubview(lbl)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrfilteredUsers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let profile_image = cell.viewWithTag(10) as! UIImageView
        let name = cell.viewWithTag(11) as! UILabel
        let img = cell.viewWithTag(12) as! UIImageView
        profile_image.layer.cornerRadius = 25.0
        profile_image.layer.masksToBounds = true
        
        
        let img_placeholder = UIImage.init(named: "user pic 1x")
        
        let url = StaticURLs.base_url + ((arrfilteredUsers[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? "")
        let avatar_url = URL.init(string: url)
        
        if(avatar_url != nil)
        {
            profile_image.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
      
        name.text = (arrfilteredUsers[indexPath.row] as! NSDictionary).object(forKey: "name") as? String
        
        let userID = (userList[indexPath.row] as! NSDictionary).object(forKey: "user_id_following") as! String
        
        if(selected_user.contains(userID))
        {
            img.image = UIImage.init(named: "Selected_radio")
        }
        else
        {
            img.image = UIImage.init(named: "unSelected_radio")
        }
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
     let userID = (userList[indexPath.row] as! NSDictionary).object(forKey: "user_id_following") as! String
        
        if(selected_user.contains(userID))
        {
            selected_user.remove(userID)
        }
        else
        {
            selected_user.add(userID)
        }
        
        self.tableview.reloadRows(at: [indexPath], with: .automatic)
        
        if(selected_user.count > 0)
        {
            btnSend.isEnabled = true
        }
        else
        {
            btnSend.isEnabled = false
        }
       
    }
   

    @IBAction func sendMessage(_ sender: Any)
    {
        
       comman.showLoader(toView: self)
        
        for id in selected_user
        {
           
            let reciever_userID = id as? String ?? ""
           
            item_description = txtField.text ?? " "
            
            network_connectivity.send_message(msg: item_description, msgType: "post", rUserId: reciever_userID, sUserId: appDel.loginUserInfo.user_id!, imgUrl: item_url, postId: item_id, pUserId: item_ownerID, object: self)
                sleep(1)
            
        }
        
        self.showToast(message: "Post has been shared")
        comman.hideLoader(toView: self)
        self.btnBack(sender)
        
       
    }
    func getUserList()
    {
        
        comman.showLoader(toView: self)
        let page_url = "user.php?username=" + appDel.loginUserInfo.username!
        web_services.badlee_get(page_url: page_url, isFuckingKey: true, success: { (data) in
            
            self.userList = (data as! NSDictionary).object(forKey: "following") as? NSArray ?? []
            self.arrfilteredUsers = self.userList
            
            if(self.arrfilteredUsers.count > 0)
            {
                self.tableview.isHidden = false
            }
            else
            {
                self.tableview.isHidden = true
            }
            self.tableview.reloadData()
            comman.hideLoader(toView: self)
            
        }) { (data) in
             comman.hideLoader(toView: self)
        }
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(Int(searchText.count) > 0)
        {
            let filter = NSPredicate(format: "name BEGINSWITH[cd] %@", searchText)
            arrfilteredUsers = userList.filtered(using: filter) as NSArray
        }
        else
        {
            arrfilteredUsers = userList
        }
        
        self.tableview.reloadData()
        
    }
    
    @IBAction func btnFollow(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "suggestedUser") as! suggestedUser
        self.present(object, animated: true, completion: nil)
    }
    
    

}
