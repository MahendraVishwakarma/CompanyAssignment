//
//  commentsVC.swift
//  Badlee
//
//  Created by Mahendra on 10/03/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import ActiveLabel
import MBProgressHUD

class comments:UITableViewCell
{
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var comments: ActiveLabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timing: UILabel!
    
}

class commentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var height_constraint: NSLayoutConstraint!
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var tableViewMessage: UITableView!
    let placeHolder = "Comments..."
    var keyBoardOpen = false
    @IBOutlet weak var constraintHeightWMsg: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomMsgType: NSLayoutConstraint!
    @IBOutlet weak var textViewTypeMsg: UITextView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var commentsView: UIView!
    
    var search_object: hashtagVC!
    var arrComments:Array<Any>!
    var post_id:Int!
    var mension_string:String!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        
        hashtagView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        hashtagView.layer.shadowOffset = CGSize(width:0.0, height:0.0)
        hashtagView.layer.shadowOpacity = 1.0
        hashtagView.layer.shadowRadius = 1
        hashtagView.layer.masksToBounds = false
 
        commentsView.layer.cornerRadius = 22
        commentsView.layer.masksToBounds = true
        commentsView.layer.borderColor = UIColor.gray.cgColor
        commentsView.layer.borderWidth = 1
        
        
        textViewTypeMsg.text = placeHolder
        textViewTypeMsg.textColor = UIColor.lightGray
        hashtagView.isHidden = true
        height_constraint.constant = 0.0
        btnSend.isEnabled = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapOnView(_:)))
        tap.numberOfTapsRequired = 1
        commentsView.addGestureRecognizer(tap)
        
        self.getPostDetails()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        self.settableenfScroll()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        textViewTypeMsg.resignFirstResponder()
      self.navigationController?.popViewController(animated: true)
      self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:comments!
        
        if((arrComments[indexPath.row] as! NSDictionary).object(forKey: "user_id") as? String ?? "" == appDel.loginUserInfo.user_id)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_my", for: indexPath) as? comments
            cell.username.text = appDel.loginUserInfo.first_name ?? ""
            let btnProfileOPen = cell.viewWithTag(1000) as! UIButton
            btnProfileOPen.addTarget(self, action: #selector(open_progile(sender:)), for: .touchUpInside)
            
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_user", for: indexPath) as? comments
            cell.username.text = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "fname") as? String ?? ""
            let btnProfileOPen = cell.viewWithTag(1000) as! UIButton
            btnProfileOPen.addTarget(self, action: #selector(open_progile(sender:)), for: .touchUpInside)
           
        }
        
        
        
        let btnReport = cell.viewWithTag(10) as! UIButton
        btnReport.addTarget(self, action: #selector(btnReport(sender:)), for: .touchUpInside)
        
        
        
        let btnReply = cell.viewWithTag(11) as! UIButton
        btnReply.addTarget(self, action: #selector(btnReply(sender:)), for: .touchUpInside)
        
        let text = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "content") as? String ?? ""
       
        cell.comments.enabledTypes = [.mention]
        //cell.comments.mentionColor = UIColor.blue
        cell.comments.highlightFontName = "Muli-Regular"
        cell.comments.highlightFontSize = 16
        cell.comments.handleMentionTap { self.alert("mention", message: $0) }
        cell.comments.text = text
     
        
        cell.img_profile.layer.cornerRadius = cell.img_profile.frame.height/2
        cell.img_profile.layer.masksToBounds = true
        
        cell.commentView.layer.cornerRadius = 12.0
        cell.commentView.layer.masksToBounds = true
        
        let str_date = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "timestamp") as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let local_date = Date()
        let server_date = dateFormatter.date(from: str_date!)!
        
        let timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
        cell.timing.text = timestamp
       
        let str_url = StaticURLs.base_url + ((arrComments[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? "")
        let avatar_url = URL.init(string: str_url)
        let img_placeholder = UIImage.init(named: "user pic 1x")
       
        if(avatar_url != nil)
        {
            cell.img_profile.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        textViewTypeMsg.resignFirstResponder()
    }
    
    @objc func tappedCell(tapped:UITapGestureRecognizer)
    {
        
        //  let t_view = tapped.view
        
        let point = tapped.location(in: tableViewMessage) // tapped location
        
        print("tapped location")
        print(point)
        
        let index = tableViewMessage.indexPathForRow(at: point)
        
        print("index path")
        print(index?.row ?? "")
        
        let cell = tableViewMessage.cellForRow(at: index!) as! comments
        
        let message = cell.comments.text!
        
        
        var arr_msgs = message.components(separatedBy: "@")
        
        for  i in 1..<arr_msgs.count
        {
            let sub_str = arr_msgs[i]
            let arr_userIDs = sub_str.components(separatedBy: " ")
            let name = search_userId(username: arr_userIDs[0])
            if(name.count > 5)
            {
               
                print("cell origin")
                print(cell.contentView.frame.minX)
                //let x1 = _iewMessage.frame.width - cell.contentView.frame.origin.x
                let tapped_location =  point.x
                
                
                // user name point ///
                let str:NSString = message as NSString
                
                let range : NSRange = str.range(of: arr_userIDs[0])
                let prefix: NSString = str.substring(to: range.location) as NSString
                let size: CGSize = prefix.size(withAttributes: [NSAttributedStringKey.font: UIFont.init(name: "Muli-Regular", size: 15) ?? 0])
                
                let widdth = (arr_userIDs[0] ).widthOfString(usingFont: UIFont.init(name: "Muli-Regular", size: 15)!)
                
                let pointt = widdth
                print(pointt)
                let p : CGPoint = CGPoint(x: size.width, y: 0)
                
                let username_range = widdth + p.x + cell.commentView.frame.origin.x
                
                if(tapped_location <= p.x && tapped_location <= username_range)
                {
                    print("you have tapped=\(arr_userIDs[0])")
                    
                    let userID = name
                    if(userID != appDel.loginUserInfo.user_id!)
                    {
                        let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
                        let isBlocked = comman.checkPermission(reciever_userID: userID)
                        let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
                        userObject.isIBlocked = isBlocked
                        userObject.userID = userID
                        self.present(userObject, animated: true, completion: nil)
                        // self.navigationController?.pushViewController(userObject, animated: true)
                    }
                    else
                    {
                        
                        guard let parent_obj = self.presentingViewController else{
                            
                            return
                        }
                        
                        self.dismiss(animated: false, completion: nil)
                        if(parent_obj .isKind(of: tabbarcontroller.self))
                        {
                            
                            (parent_obj as! tabbarcontroller).selectedIndex = 4
                            
                        }
                        print(parent_obj)
                        
                        
                        
                        
                    }
                }
                
                
            }
           
          
        }
        
        
        
    }
    
    
    //MARK:- text view
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //  print("1")
        //   print("textView \(textView.text)")
        
        
       
        
        if let text2 = textView.text as NSString? {
            
            let txtAfterUpdate = text2.replacingCharacters(in: range, with: text as String)
            
            let arr = txtAfterUpdate.components(separatedBy: "@")
            //print("txtAfterUpdate \(txtAfterUpdate)")
            
            if(text == "@" || txtAfterUpdate == "@")
            {
               
                let search_char = arr.last ?? ""
                search_object.searchName(name: search_char)
                 self.tableview_up()
            }
            else if(Int(arr.last!.count) > 0 && arr.count > 1)
            {
                
                let search_char = arr.last ?? ""
//                search_char.removeFirst()
                search_object.searchName(name: search_char)
                self.tableview_up()
                if(search_object.user_child_list.count <= 0)
                {
                     self.tableview_down()
                }
            }
            else
            {
                self.tableview_down()
            }
            if(Int(txtAfterUpdate.trimmingCharacters(in: .whitespaces).count) > 0)
            {
                 btnSend.isEnabled = true
                if(search_object != nil && text != "@")
                {
                    
                }
            }
            else
            {
                 btnSend.isEnabled = false
            }
            
            let txtMsgHeight = String.height(txtAfterUpdate) (withConstrainedWidth: textView.frame.size.width - 10, font: textView.font!) + 5 + 12
            
           
            
            if txtMsgHeight > 120 {
                constraintHeightWMsg.constant = 120
            }
                
            else{
                
                constraintHeightWMsg.constant = txtMsgHeight
                if textView.text == "" {
                }
                
            }
            
            
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == placeHolder {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == placeHolder || textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = placeHolder
            constraintHeightWMsg.constant = 37
        }
    }
    
    
    
    func tableview_up()
    {
       
            hashtagView.isHidden = false
           
            UIView.animate(withDuration: 0.4, animations: {
                if(self.search_object != nil)
                {
                    if(self.search_object.tableview.contentSize.height >= 250)
                    {
                      self.height_constraint.constant = 250
                    }
                    else
                    {
                        self.height_constraint.constant = CGFloat(self.search_object.user_child_list.count*60)
                    }
                }
                
                
            })
            
        
    }
    func tableview_down()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.height_constraint.constant = 0
            
        })
    }

    func textViewDidChange(_ textView: UITextView)
    {
      
        
        if textView.text == placeHolder || textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = ""
            
        }
        else{
            textView.textColor = UIColor.black
            
        }
        
        if textView.text.count == 0 {
            
        }
        else
        {
            
        }
        
        if textView.contentSize.height <= 34.0
        {
            
        }
        
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        self.settableenfScroll()
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = (keyboardFrame.height ) * (show ? 1 : 0)
        
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.constraintBottomMsgType.constant = changeInHeight
            self.view.layoutIfNeeded()
        })
        
        
    }
    @IBAction func tapOnView(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnUserTapped(_ sender: UIButton)
    {
        let cell = sender.superview?.superview as? comments
        let indexPath = tableViewMessage.indexPath(for: cell!)
        
        let userID = (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "user_id")  as? String
        
        if(userID != appDel.loginUserInfo.user_id!)
        {
            let isBlocked = comman.checkPermission(reciever_userID: userID!)
            let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
            let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
            userObject.isIBlocked = isBlocked
            userObject.userID = userID
            //self.present(userObject, animated: true, completion: nil)
            self.navigationController?.pushViewController(userObject, animated: true)
        }
        else
        {
            self.tabBarController?.selectedIndex = 4
        }
        
        
    }
    
    
    @IBAction func btnSendComment(_ sender: UIButton)
    {
        
       
        if(textViewTypeMsg.text == nil || textViewTypeMsg.text == "Comments..." || Int(textViewTypeMsg.text.trimmingCharacters(in: .whitespaces).count) == 0)
        {
            return
        }
        
        let mension_str = self.convert_mensionData(message: textViewTypeMsg.text.trimmingCharacters(in: .whitespaces))
        
        let message = mension_str
        
        let param = ["application_id":app_id,"application_secret":app_secret_key,"postid":post_id!,"content":message] as [String : Any]
        
        comman.showLoader(toView: self)
        print(param)
        self.textViewTypeMsg.text = nil
        constraintHeightWMsg.constant = 38
        btnSend.isEnabled = false
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "comment.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            let comments_data = data as! NSDictionary
            
            self.arrComments.append(comments_data)
            
            self.tableViewMessage.reloadData()
            self.textViewTypeMsg.text = nil
            self.settableenfScroll()
            
          //  print(data)
            
            comman.hideLoader(toView: self)
            
        }) { (data) in
            
           // print(data)
            comman.hideLoader(toView: self)
            
        }
    }
    
    @objc func open_progile(sender:UIButton)
    {
        let cell = sender.superview?.superview as? comments
        let indexPath = tableViewMessage.indexPath(for: cell!)
        let userID = (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "user_id") as? String ?? ""
        if(userID != appDel.loginUserInfo.user_id!)
        {
            let isBlocked = comman.checkPermission(reciever_userID: userID)
            
            let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
            let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
            userObject.isIBlocked = isBlocked
            userObject.userID = userID
            self.present(userObject, animated: true, completion: nil)
           // self.navigationController?.pushViewController(userObject, animated: true)
        }else{
            guard let parent_obj = self.presentingViewController else{
                
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)
            if(parent_obj .isKind(of: tabbarcontroller.self))
            {
                (parent_obj as! tabbarcontroller).selectedIndex = 4
            }
        }
        
        
    }
    
    @objc func btnReport(sender:UIButton)
    {
        let cell = sender.superview?.superview as? comments
        let indexPath = tableViewMessage.indexPath(for: cell!)
        let comment_id = (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "comment_id") as? Int ?? 0
        
      
        let optionMenu = UIAlertController(title: nil, message: "Choose a reason for reporting this comment:", preferredStyle: .actionSheet)
        
        let spam = UIAlertAction(title: "It's spam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.reporting(message: "It's a spam", itemid: "\(comment_id)", itemtype: "comment")
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        
        let inappropriate = UIAlertAction(title: "It's inappropriate", style: .default, handler: { (alert: UIAlertAction!) -> Void in
           self.reporting(message: "It's inappropriate", itemid: "\(comment_id)", itemtype: "comment")
        })
        
        
        optionMenu.addAction(spam)
        optionMenu.addAction(inappropriate)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func reporting(message:String,itemid:String,itemtype:String)
    {
        let dict = ["itemid":itemid, "itemtype":itemtype,"message":message,"application_id":app_id,"application_secret":app_secret_key]
        
        web_services.badlee_postitem_with_param(param: dict as NSDictionary, page_url: "report.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
             self.showToast(message: "Report has been accepted")
            
        }) { (data) in
             self.showToast(message: "Something went wrong")
        }
        
       
    }
    
    @objc func btnReply(sender:UIButton)
    {
        textViewTypeMsg.text = nil
        let cell = sender.superview?.superview as? comments
        let indexPath = tableViewMessage.indexPath(for: cell!)
        
        let userID = String(describing: (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "user_id") as? String ?? "")
        
        var username = ""
        if(userID == appDel.loginUserInfo.user_id)
        {
            username = "@" +  String(describing: (appDel.loginUserInfo.username ?? ""))
        }
        else
        {
             username = "@" + String(describing: (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "username") as? String ?? "")
            
        }
        
       
        self.setup_mention(data: username)
        btnSend.isEnabled = true
        textViewTypeMsg.becomeFirstResponder()
        
    }
    
    
    func settableenfScroll()
    {
        let index = NSIndexPath.init(item: arrComments.count - 1, section: 0)
        
        if(index.row < arrComments.count && index.row >= 0)
        {
            tableViewMessage.scrollToRow(at: index as IndexPath, at: .top, animated: true)
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "hashtagVC")
        {
            let searchObject = segue.destination  as! hashtagVC
            search_object = searchObject
            
        }
    }
    
    func setup_mention(data:String)
    {

        let searchQuery = data
        let message = data + " "
        
        let range = (message as NSString).range(of: searchQuery)
        
       
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-Bold", size: 15) ?? "", range: range)
        
       let  main_message = NSMutableAttributedString.init(attributedString: textViewTypeMsg.attributedText)
        main_message.append(attributedString)
        
        textViewTypeMsg.attributedText = main_message
        
        self.tableview_down()
        
    }
    
    func convert_mensionData(message:String) -> String
    {
        var arr_msgs = message.components(separatedBy: "@")
        
        for  i in 1..<arr_msgs.count
        {
            let sub_str = arr_msgs[i]
            var arr_userIDs = sub_str.components(separatedBy: " ")
            arr_userIDs[0] = create_userID(data: search_userId(username: arr_userIDs[0]))
            var complete_str = ""
            for j in 0..<arr_userIDs.count
            {
                complete_str = complete_str + arr_userIDs[j] + " "
            }
            arr_msgs[i] = complete_str
            
        }
        
        var complete_str = ""
        for j in 0..<arr_msgs.count
        {
            complete_str = complete_str + arr_msgs[j]
        }
        
        return complete_str
        
    }
    
    func create_userID(data:String) -> String
    {
        var done_string = ""
        
        done_string = "[mention]" + data + "[/mention]"
        
        return done_string
    }
    
    func search_userId(username:String) -> String
    {
        var user_id = ""
        
        let resultPredicate = NSPredicate(format: "username BEGINSWITH[cd] %@ or username BEGINSWITH[cd] %@", username, username)
            
        let  user_info = search_object.user_list.filtered(using: resultPredicate) as NSArray
            print(user_info)
        
        if(Int(user_info.count) > 0)
        {
            user_id = (user_info[0] as! NSDictionary).object(forKey: "user_id_follower") == nil ? (user_info[0] as! NSDictionary).object(forKey: "user_id_following") as! String : (user_info[0] as! NSDictionary).object(forKey: "user_id_follower") as! String
        }
        
        if(username == appDel.loginUserInfo.username)
        {
            user_id = appDel.loginUserInfo.user_id!
        }
        
        
        return user_id
    }
    
    func getPostDetails()
    {
        
        comman.showLoader(toView: self)
        
        web_services.badlee_get(page_url: "posts.php?postid=\(post_id!)", isFuckingKey: true, success: { (data) in
            
            comman.hideLoader(toView: self)
            
            self.arrComments = (data as? NSDictionary)?.object(forKey: "comments") as? NSArray as? Array<Any>
            self.tableViewMessage.reloadData()
            print(data ?? "")
            
        }) { (error) in
            
             comman.hideLoader(toView: self)
            print("error = \(String(describing: error) )")
        }
    }
    
    func alert(_ title: String, message: String) {
        
        self.goto_profile(usrname: message)
        
    }
    
    func goto_profile(usrname:String)
    {
        if(usrname == appDel.loginUserInfo.username!)
        {
            guard let parent_obj = self.presentingViewController else{
                
                return
            }
            
            self.dismiss(animated: false, completion: nil)
            if(parent_obj .isKind(of: tabbarcontroller.self))
            {
                
                (parent_obj as! tabbarcontroller).selectedIndex = 4
                
            }
            print(parent_obj)
            return
        }
        
        let page_url = "user.php?username=" + usrname
        
        let obj =  MBProgressHUD.showAdded(to: self.view, animated: true)
        obj.detailsLabel.text = "Checking user..."
        
        web_services.badlee_get(page_url: page_url, isFuckingKey: true, success: { (data) in
            
            
            if(usrname != appDel.loginUserInfo.username!)
            {
                let id = (data as? NSDictionary)?.object(forKey: "user_id") as? String ?? ""
                let isBlocked = comman.checkPermission(reciever_userID: id)
                let strbrd = UIStoryboard.init(name: "Main", bundle: nil)
                let userObject = strbrd.instantiateViewController(withIdentifier: "userProfile") as! userProfile
                userObject.isIBlocked = isBlocked
                userObject.userID = id
                self.present(userObject, animated: true, completion: nil)
                //self.navigationController?.pushViewController(userObject, animated: true)
            }
            else
            {
                
                guard let parent_obj = self.presentingViewController else{
                    
                    return
                }
                
                self.dismiss(animated: false, completion: nil)
                if(parent_obj .isKind(of: tabbarcontroller.self))
                {
                    
                    (parent_obj as! tabbarcontroller).selectedIndex = 4
                    
                }
                print(parent_obj)
                
            }
            
            obj.hide(animated: true)
            //comman.hideLoader(toView: self)
            
        }) { (error) in
            
            self.showToast(message: "User not found")
            obj.hide(animated: true)
           // comman.hideLoader(toView: self)
        }
        
      
    }
    
}
extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        
        let myString: NSString = self as NSString
        let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: font])
        
        return size.height
        
}
}
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    
}

