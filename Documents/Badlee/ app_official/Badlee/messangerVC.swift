

import UIKit
import MBProgressHUD


class messangerVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate, chatparant {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnUsername: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    
    var user_name:String!
    var profile_image:UIImage!
    var arrChatData_read  = NSMutableArray()
    var arrChatData_unread  = NSMutableArray()
    var arrSections = NSMutableArray()
    
    var preDay = ""
    @IBOutlet weak var bottom_constraight: NSLayoutConstraint!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var view_chat: UIView!
    var reciever_userID:String!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        let isBlocked = comman.checkPermission(reciever_userID: reciever_userID)
        blockView.isHidden = true
        if(isBlocked)
        {
            blockView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view_chat.layer.shadowColor =  UIColor.gray.cgColor
        view_chat.layer.shadowOpacity = 1
        view_chat.layer.shadowOffset = CGSize(width:0, height:0)
        view_chat.layer.shadowRadius = 3
        view_chat.backgroundColor = .clear
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        self.lblUsername.text = user_name
        
        if(profile_image != nil)
        {
            self.imgProfilePic.image = profile_image
        }
        
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
        imgProfilePic.layer.masksToBounds = true
        
        network_connectivity.parantDelegate = self
        network_connectivity.isReeading = true
        network_connectivity.client_userID = reciever_userID
        self.getUserInfo(hostID: reciever_userID)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.fetch_pre_Chat()
        
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       print(UIApplication.shared.applicationState)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        network_connectivity.isReeading = false
        network_connectivity.client_userID = ""
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        //self.refreshData()
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
       // self.refreshData()
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func tappedOnView(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(arrChatData_unread.count > 0)
        {
            return arrSections.count + 1
        }
        else
        {
            return arrSections.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let font =  UIFont.init(name: "Muli-Regular", size: 14)
        let lbl_count = UILabel()
        
        lbl_count.font = font
        lbl_count.backgroundColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 0.7)
        lbl_count.layer.cornerRadius = 15
        lbl_count.layer.masksToBounds = true
        lbl_count.textAlignment = .center
        lbl_count.textColor = UIColor.white
        
        if(section >= (arrSections.count))
        {
            let header_view = UIView.init(frame: CGRect(x:0,y:0,width:tableView.frame.width,height:50))
            header_view.backgroundColor = UIColor.clear
            
            let string_total  = "\(arrChatData_unread.count) Unread Messages"
            let width_string = string_total.width(withConstrainedWidth: 50, font: font!) + 16
            lbl_count.frame =  CGRect(x:(tableView.frame.width - width_string)/2,y:10,width:width_string ,height:30)
            
            if(arrChatData_unread.count > 1)
            {
                lbl_count.text = "\(arrChatData_unread.count) Unread Messages"
            }
            else
            {
                lbl_count.text = "\(arrChatData_unread.count) Unread Message"
            }
            header_view.addSubview(lbl_count)
            return header_view
        }
        else
        {
            let header_view = UIView.init(frame: CGRect(x:0,y:0,width:tableView.frame.width,height:20))
            let item = arrSections[section] as? NSDictionary ?? [:]
            let timestamp : Int64 = Int64(item.object(forKey: "timestamp") as! Int64)
            let day = comman.dayOfDate(from: TimeInterval(timestamp))
            
            let width_string =  CGFloat(100) //day.width(withConstrainedWidth: 50, font: font!) + 25
            lbl_count.frame =  CGRect(x:(tableView.frame.width - width_string)/2,y:10,width:width_string ,height:30)
            lbl_count.text = day
            header_view.addSubview(lbl_count)
            return header_view
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(arrSections.count > 0)
        {
            return 60
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if(section < arrSections.count && section >= 0)
        {
            let item = arrSections[section] as? NSDictionary ?? [:]
            let day = item.object(forKey: "day") as? String ?? ""
            let resultPredicate = NSPredicate(format: "day contains[cd] %@", day)
            let isFound = arrChatData_read.filtered(using: resultPredicate)
            
            return isFound.count
        }
        else
        {
            return arrChatData_unread.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var nor = 0
        
        if(indexPath.section >= 0 && indexPath.section < arrSections.count)
        {
            for section in 0..<(indexPath.section)
            {
                print(section)
                let item = arrSections[section] as? NSDictionary ?? [:]
                let day = item.object(forKey: "day") as? String ?? ""
                let resultPredicate = NSPredicate(format: "day contains[cd] %@", day)
                let isFound = arrChatData_read.filtered(using: resultPredicate)
                nor = nor + isFound.count
                
            }
        }
        else
        {
            nor = arrChatData_read.count + 1
        }
        
        
        let row = indexPath.row + nor
        
        let chat = row < arrChatData_read.count ? arrChatData_read[row] as! NSDictionary : arrChatData_unread[indexPath.row] as! NSDictionary
        let timestamp : Int64 = Int64(chat.object(forKey: "timestamp") as! Int64)
        
        if(chat.object(forKey: "sChatId") as? String == appDel.loginUserInfo.user_id!)
        {
            
            if((chat.object(forKey: "msgType") as? String) == "text")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_mine", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblDate = cell.viewWithTag(30) as! UILabel
                
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                
                view_back?.layer.cornerRadius = 52/2
                view_back?.layer.masksToBounds = true
                
                let lblMessage = cell.viewWithTag(10) as! CopyableLabel
                
                lblMessage.text = chat.object(forKey: "message") as? String ?? ""
                
                return cell
                
            }
                
            else if((chat.object(forKey: "msgType") as? String) == "post")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_shareimage_mine", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblMessage = cell.viewWithTag(11) as! CopyableLabel
                let lblUserName = cell.viewWithTag(10) as! UILabel
                let img_sent = cell.viewWithTag(12) as! UIImageView
                let lblDate = cell.viewWithTag(30) as! UILabel
                let profile_pic = cell.viewWithTag(9) as! UIImageView
                let img_purpose = cell.viewWithTag(102) as! UIImageView
                
                profile_pic.layer.cornerRadius = profile_pic.frame.height/2
                profile_pic.layer.masksToBounds = true
                
                let activity_indicator = cell.viewWithTag(1010) as! UIActivityIndicatorView
                let buttonTapped = cell.viewWithTag(101) as! UIButton
                
                buttonTapped.addTarget(self, action: #selector(share_itemTapped(sender:)), for: .touchUpInside)
                
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                view_back?.layer.cornerRadius = 52/2
                view_back?.layer.masksToBounds = true
                
                let postID = chat.object(forKey: "postId") as? String ?? ""
                let url_full = "posts.php?postid=\(postID)"
                activity_indicator.startAnimating()
                web_services.badlee_getUserInfo(page_url: url_full, isFuckingKey: true, success: { (data) in
                    // print(data)
                    let info = data as?  NSDictionary ?? [:]
                    let media = info.object(forKey: "media") as? String ?? ""
                    let url_str = StaticURLs.base_url + media
                    let url = URL.init(string: url_str)
                    if(url != nil)
                    {
                        img_sent.setImageWith(url!, placeholderImage: UIImage.init(named: "image_icon"))
                        
                    }
                    
                    let reaction_name = info.object(forKey: "purpose") as? String ?? ""
                    img_purpose.image = comman.getReaction(reactionName: reaction_name)
                    let user = info.object(forKey: "user_info") as? NSDictionary ?? [:]
                    
                    lblUserName.text = user.object(forKey: "username") as? String ?? ""
                    let profileURL_str = user.object(forKey: "avatar") as? String ?? ""
                    let profileURL = StaticURLs.base_url + profileURL_str
                    let url_pro = URL.init(string: profileURL)
                    if(url != nil)
                    {
                        profile_pic.setImageWith(url_pro!, placeholderImage: UIImage.init(named: "image_icon"))
                        
                    }
                    activity_indicator.stopAnimating()
                    
                }) { (error) in
                    
                    activity_indicator.stopAnimating()
                    
                }
                
                lblMessage.text = chat.object(forKey: "message") as? String
                
                return cell
                
            }
            else if((chat.object(forKey: "msgType") as? String) == "image")
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_image_mine", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblDate = cell.viewWithTag(30) as! UILabel
                
                let activity_indicator = cell.viewWithTag(1010) as! UIActivityIndicatorView
                
                view_back?.layer.cornerRadius = 15
                view_back?.layer.masksToBounds = true
                
                let buttonTapped = cell.viewWithTag(104) as! UIButton
                
                buttonTapped.addTarget(self, action: #selector(imageZoomTapped(sender:)), for: .touchUpInside)
                
                
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                
                let img_sent = cell.viewWithTag(12) as! UIImageView
                
                img_sent.layer.cornerRadius = 10
                img_sent.layer.masksToBounds = true
                
                img_sent.layer.borderColor = UIColor.gray.cgColor
                img_sent.layer.borderWidth = 1
                
                let url_full = StaticURLs.base_url + (chat.object(forKey: "imgUrl") as? String)!
                activity_indicator.startAnimating()
                let request = URLRequest.init(url: URL.init(string: url_full)!)
                img_sent.setImageWith(request, placeholderImage:  UIImage.init(named: "image_icon"), success: { (request, res, img) in
                    
                    img_sent.image = img
                    activity_indicator.stopAnimating()
                }) { (req, resp, err) in
                    activity_indicator.stopAnimating()
                }
                
                return cell
                
            }
            else if((chat.object(forKey: "msgType") as? String) == "like")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_like_mine", for: indexPath)
                let img_sent = cell.viewWithTag(10) as! UIImageView
                let lblDate = cell.viewWithTag(30) as! UILabel
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                img_sent.image = UIImage.init(named: "like 1x")
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_image_mine", for: indexPath)
                return cell
            }
            
        }
        else
        {
            
            if((chat.object(forKey: "msgType") as? String) == "text")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_your", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblDate = cell.viewWithTag(30) as! UILabel
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                view_back?.layer.cornerRadius = 52/2
                view_back?.layer.masksToBounds = true
                view_back?.layer.borderColor = UIColor.init(red: 238/255.0, green: 224.0/255.0, blue: 241.0/255.0, alpha: 1).cgColor
                view_back?.layer.borderWidth = 1
                let lblMessage = cell.viewWithTag(11) as! CopyableLabel
                lblMessage.text = chat.object(forKey: "message") as? String
                return cell
            }
            else if((chat.object(forKey: "msgType") as? String) == "post")
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_shareimage_yours", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblDate = cell.viewWithTag(30) as! UILabel
                let buttonTapped = cell.viewWithTag(101) as! UIButton
                let img_purpose = cell.viewWithTag(102) as? UIImageView
                buttonTapped.addTarget(self, action: #selector(share_itemTapped(sender:)), for: .touchUpInside)
                let activity_indicator = cell.viewWithTag(1010) as! UIActivityIndicatorView
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                view_back?.layer.cornerRadius = 52/2
                view_back?.layer.masksToBounds = true
                let lblMessage = cell.viewWithTag(11) as! CopyableLabel
                let lblUserName = cell.viewWithTag(10) as! UILabel
                let img_sent = cell.viewWithTag(12) as! UIImageView
                let profile_pic = cell.viewWithTag(9) as! UIImageView
                profile_pic.layer.cornerRadius = profile_pic.frame.height/2
                profile_pic.layer.masksToBounds = true
                let postID = chat.object(forKey: "postId") as? String ?? ""
                let url_full = "posts.php?postid=\(postID)"
                activity_indicator.startAnimating()
                web_services.badlee_getUserInfo(page_url: url_full, isFuckingKey: true, success: { (data) in
                    print(data ?? "")
                    let info = data  as? NSDictionary ?? [:]
                    let media = info.object(forKey: "media") as? String ?? ""
                    let url_str = StaticURLs.base_url + media
                    let url = URL.init(string: url_str)
                    if(url != nil)
                    {
                        img_sent.setImageWith(url!, placeholderImage: UIImage.init(named: "image_icon"))
                        
                    }
                    
                    activity_indicator.stopAnimating()
                    
                    let reaction_name = info.object(forKey: "purpose") as? String ?? ""
                    img_purpose?.image = comman.getReaction(reactionName: reaction_name)
                    let user = info.object(forKey: "user_info") as? NSDictionary ?? [:]
                    lblUserName.text = user.object(forKey: "username") as? String ?? ""
                    let profileURL_str = user.object(forKey: "avatar") as? String ?? ""
                    let profileURL = StaticURLs.base_url + profileURL_str
                    let url_pro = URL.init(string: profileURL)
                    if(url != nil)
                    {
                        profile_pic.setImageWith(url_pro!, placeholderImage: UIImage.init(named: "image_icon"))
                    }
                    
                }) { (error) in
                    
                    activity_indicator.stopAnimating()
                    //print(error?.localizedDescription)
                }
                
                lblMessage.text = chat.object(forKey: "message") as? String
                return cell
                
            }
            else if((chat.object(forKey: "msgType") as? String) == "image")
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_image_your", for: indexPath)
                let view_back = cell.viewWithTag(1)
                let lblDate = cell.viewWithTag(30) as! UILabel
                
                view_back?.layer.cornerRadius = 15
                view_back?.layer.masksToBounds = true
                lblDate.text = comman.timestamp_to_date(timestamp: timestamp)
                let img_sent = cell.viewWithTag(12) as! UIImageView
                img_sent.layer.cornerRadius = 10
                img_sent.layer.masksToBounds = true
                img_sent.layer.borderColor = UIColor.gray.cgColor
                img_sent.layer.borderWidth = 1
                let buttonTapped = cell.viewWithTag(104) as! UIButton
                buttonTapped.addTarget(self, action: #selector(imageZoomTapped(sender:)), for: .touchUpInside)
                
                let activity_indicator = cell.viewWithTag(1000) as! UIActivityIndicatorView
                
                let url_full = StaticURLs.base_url + ((chat.object(forKey: "imgUrl") as? String ?? ""))
                
                activity_indicator.startAnimating()
                let request = URLRequest.init(url: URL.init(string: url_full)!)
                img_sent.setImageWith(request, placeholderImage: UIImage.init(named: "image_icon"), success: { (request, res, img) in
                    
                    img_sent.image = img
                    activity_indicator.stopAnimating()
                }) { (req, resp, err) in
                    activity_indicator.stopAnimating()
                }
                return cell
                
            }
                
            else if((chat.object(forKey: "msgType") as? String) == "like")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_like_your", for: indexPath)
                let img_sent = cell.viewWithTag(10) as! UIImageView
                let lblDate = cell.viewWithTag(30) as! UILabel
                let timestamp : Int64 = Int64(chat.object(forKey: "timestamp") as! Int64)
                lblDate.text = comman.timestamp_to_time(timestamp: timestamp)
                img_sent.image = UIImage.init(named: "like 1x")
                return cell
            }
                
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_image_mine", for: indexPath)
                return cell
            }
        }
        
    }
    
    @IBAction func btnMediaTapped(_ sender: Any)
    {
        let isblocked = comman.checkPermission(reciever_userID: reciever_userID)
        
        if(isblocked)
        {
            return
        }
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select option", message: "options", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.modalPresentationStyle = .overCurrentContext
                //imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Photo Liberary", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.modalPresentationStyle = .overCurrentContext
                //imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        self.upload_image(uploading_image: image)
        
    }
    
    //MARK: -message send-
    
    @IBAction func btnSendMessage(_ sender: Any)
    {
        //arrChatData_unread.removeAllObjects()
        let countChar : Int = (txtMessage.text?.count)!
        let isblocked = comman.checkPermission(reciever_userID: reciever_userID)
        
        if(countChar <= 0 || isblocked)
        {
            return
        }
        
        network_connectivity.send_message(msg: txtMessage.text!, msgType: "text", rUserId: reciever_userID!, sUserId: appDel.loginUserInfo.user_id!, imgUrl: "", postId: "", pUserId: "", object: self)
        self.txtMessage.text = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated:true, completion: nil)
    }
    
    func zoom_image()
    {
        
    }
    
    
    //MARK: -got message-
    
    func refreshData()
    {
        
        if(self.arrSections.count > 0)
        {
          
            self.fetch_pre_Chat()
//            var ros = self.chatTableView.numberOfRows(inSection: self.arrSections.count-1)
//            ros = ros > 0 ? ros: 1
//            let index = IndexPath.init(item: ros-1, section: self.arrSections.count-1)
//            self.chatTableView.scrollToRow(at: index as IndexPath, at: .bottom, animated: true)
        }
    }
    
    func fetch_pre_Chat()
    {
        
        arrChatData_read.removeAllObjects()
        arrChatData_unread.removeAllObjects()
        arrSections.removeAllObjects()
        
        let readData = DBManager.shared.AllChat_read(loginID: appDel.loginUserInfo.user_id!, userID: reciever_userID)
        let UnreadData = DBManager.shared.AllChat_unread(loginID:  appDel.loginUserInfo.user_id!, userID: reciever_userID)
        let sortedArray = comman.sortArraybyTimestamp(arr: readData)
        let sortedUnreadArray = comman.sortArraybyTimestamp(arr: UnreadData)
        arrChatData_read.addObjects(from: sortedArray as! [Any])
        arrChatData_unread.addObjects(from: sortedUnreadArray as! [Any])
        for item in arrChatData_read
        {
            let day = (item as! NSDictionary).object(forKey: "day") as? String ?? ""
            let resultPredicate = NSPredicate(format: "day contains[cd] %@", day)
            let isFound = arrSections.filtered(using: resultPredicate)
            if(isFound.count <= 0)
            {
                arrSections.add(item)
            }
        }
        
        self.chatTableView.reloadData()
        
        if(arrChatData_unread.count > 0)
        {
            let index = IndexPath.init(item: 0, section: self.arrSections.count)
            self.chatTableView.scrollToRow(at: index, at: .bottom, animated: false)
        }else {
            
            if(self.arrSections.count > 0){
                let ros = self.chatTableView.numberOfRows(inSection: self.arrSections.count-1)
                let index = IndexPath.init(item: ros-1, section: self.arrSections.count-1)
                self.chatTableView.scrollToRow(at: index, at: .bottom, animated: false)
            }
            
        }
        
        //set all chat read
        DBManager.shared.update_message_status(userID: reciever_userID, loginID: appDel.loginUserInfo.user_id!)
        
    }
    
    func message_sent(data: NSDictionary)
    {
        if(data.object(forKey: "sChatId") as? String == appDel.loginUserInfo.user_id! || data.object(forKey: "sChatId") as? String == reciever_userID)
        {
            
            DispatchQueue.main.async {
                
                if(self.arrChatData_unread.count > 0)
                {
            
                    self.fetch_pre_Chat()
                }else{
                    
                    self.arrChatData_read.add(data)
                   // self.chatTableView.reloadData()
                    
                    let day = data.object(forKey: "day") as? String ?? ""
                    let resultPredicate = NSPredicate(format: "day contains[cd] %@", day)
                    let isFound = self.arrSections.filtered(using: resultPredicate)
                    if(isFound.count <= 0)
                    {
                        self.arrSections.add(data)
                    }
                    
                    
                    let ros = self.chatTableView.numberOfRows(inSection: self.arrSections.count-1)
                    self.chatTableView.beginUpdates()
                    let index = IndexPath.init(item: ros, section: self.arrSections.count-1)
                    print(index.row)
                    self.chatTableView.insertRows(at: [index], with: .none)
                    
                    self.chatTableView.endUpdates()
                    
                    self.chatTableView.scrollToRow(at: index as IndexPath, at: .bottom, animated: true)
                   
                }
                
            }
            
        }
        
    }
    
    func message_recieved(data: NSDictionary)
    {
        
        //arrChatData_unread.removeAllObjects()
       // arrChatData_read.add(data)
       // self.fetch_pre_Chat()
        self.refreshData()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(arrChatData_unread.count > 0)
        {
            arrChatData_unread.removeAllObjects()
            self.fetch_pre_Chat()
            
        }
        
    }
    
    @IBAction func btnLike(_ sender: Any)
    {
        let isBlocked = comman.checkPermission(reciever_userID: reciever_userID)
        if(isBlocked)
        {
            return
        }
        network_connectivity.send_message(msg: "👌", msgType: "like", rUserId: reciever_userID, sUserId: appDel.loginUserInfo.user_id!, imgUrl: "", postId: "", pUserId: "", object: self)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func upload_image(uploading_image:UIImage)
    {
        
        DispatchQueue.main.async {
            
            let obj =  MBProgressHUD.showAdded(to: self.view, animated: true)
            obj.detailsLabel.text = "compressing image"
            
            let compression = ImageCompression()
            let imageToUpload = compression.imageCompression(image: uploading_image)
            if(!imageToUpload.1){
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showToast(message: "Image should be less than 500kb")
                return
            }
            obj.detailsLabel.text = "uploading image"
            
            web_services.upload_image(page_url: "media.php", uploading_image: imageToUpload.0, username: appDel.loginUserInfo.username, password: appDel.loginUserInfo.password, success: { (data) in
                
                DispatchQueue.main.async
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        guard let url = (data as! NSDictionary).object(forKey: "url") as? String else {
                            self.showToast(message: (data as! NSDictionary).object(forKey: "error") as? String ?? "")
                            return
                        }
                        network_connectivity.send_message(msg: "🏞 image sent", msgType: "image", rUserId: self.reciever_userID, sUserId: appDel.loginUserInfo.user_id!, imgUrl: url, postId: "", pUserId: "", object: self)
                        
                }
                
                
            }) { (data) in
                
               MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        
        
    }
    
    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?)
    {
        if let error = error {
            
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            
            print(path)
            print(contextInfo!)
            
        }
        
    }
    
    @objc func imageZoomTapped(sender:UIButton)
    {
        guard let cell = sender.superview?.superview?.superview as? UITableViewCell else { return }
        
        let imgView = cell.viewWithTag(12) as! UIImageView
        
        let object = self.storyboard?.instantiateViewController(withIdentifier: "zoomImage") as! zoomImage
        
        object.imageSelected = imgView.image
        
        object.modalPresentationStyle = .overCurrentContext
        
        self.present(object, animated: false, completion: nil)
        
    }
    
    
    @objc func share_itemTapped(sender:UIButton)
    {
       
        guard let cell = sender.superview?.superview?.superview as? UITableViewCell else { return }
        let index:IndexPath = chatTableView.indexPath(for: cell)!
        
        print(index.section)
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let post_id = (arrChatData_read[index.row + index.section] as! NSDictionary).object(forKey: "postId") as? String ?? ""
        
        if(post_id == "") {
            return
        }
        
        let object_itemDescription = strbrd.instantiateViewController(withIdentifier: "singlePage") as! singlePage
        object_itemDescription.post_id = Int(post_id)
        self.present(object_itemDescription, animated: true, completion: nil)
        
    }
    
    @IBAction func btnProfileTapped(_ sender: Any) {
        
        let userID = reciever_userID
        let userObject = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        let isBlocked = comman.checkPermission(reciever_userID: reciever_userID)
        userObject.isIBlocked = isBlocked
        userObject.userID = userID
        
        self.present(userObject, animated: true, completion: nil)
    }
    @IBAction func btnMenu(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        let isBlocked = comman.checkPermission(reciever_userID: reciever_userID)
        let view_profile = UIAlertAction(title: "View Profile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let userID = self.reciever_userID
            let userObject = self.storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
            userObject.userID = userID
            userObject.isIBlocked = isBlocked
            self.present(userObject, animated: true, completion: nil)
            
        })
        
        
        let block_msg = isBlocked == true ? "Unblock User" : "Block User"
        
        let block_user = UIAlertAction(title: block_msg, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if(isBlocked) {
                self.unblockthisUser(userID: self.reciever_userID!)
                return
            }
            comman.showLoader(toView: self)
            web_services.badlee_post_with_authentication(page_url: "block.php?userid=\(self.reciever_userID!)", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                //print(data!)
                self.blockView.isHidden = false
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                self.showToast(message: "User has been blocked")
                
                comman.hideLoader(toView: self)
                
            }, failure: { (error) in
                comman.hideLoader(toView: self)
            })
        })
        
        let report_user = UIAlertAction(title: "Report User", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.doReport(userID: self.reciever_userID, itemtype: "user")
        })
        
        optionMenu.addAction(UIAlertAction(title: "Clear Chat", style: .default, handler: { (alrt) in
            
            DBManager.shared.clearChat(userID: self.reciever_userID)
            
            DispatchQueue.main.async {
                self.arrChatData_read.removeAllObjects()
                self.arrChatData_unread.removeAllObjects()
                self.arrSections.removeAllObjects()
                self.chatTableView.reloadData()
            }
            
        }))
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
       
        
        optionMenu.addAction(view_profile)
        optionMenu.addAction(block_user)
        optionMenu.addAction(report_user)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func unblockthisUser(userID:String)
    {
        let user_id = userID
        
        comman.showLoader(toView: self)
        web_services.badlee_delete_with_authentication(page_url: "block.php?userid=\(user_id)", username: appDel.loginUserInfo.username!, password:
            
            appDel.loginUserInfo.password!, success: { (data) in
                print(data!)
                self.blockView.isHidden = true
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                self.showToast(message: "User has been unblocked")
                comman.hideLoader(toView: self)
                
                
        }) { (error) in
            
            comman.hideLoader(toView: self)
        }
    }
    
    func getUserInfo(hostID:String)
        
    {
        web_services.badlee_get(page_url: "user.php?userid=\(hostID)", isFuckingKey: true, success: { (data) in
            
            let strURL = (data as? NSDictionary)?.object(forKey: "avatar") as? String ?? ""
            let username = (data as? NSDictionary)?.object(forKey: "username") as? String ?? ""
            
            self.lblUsername.text = username
            let profile_url  = StaticURLs.base_url + strURL
            
            let avatarURl = URL.init(string: profile_url)
            
            if(avatarURl != nil)
            {
                self.imgProfilePic.setImageWith(avatarURl!, placeholderImage: UIImage.init(named: "user pic 1x"))
            }
            
            
        }) { (error) in
            
            
        }
        
    }
    
    func doReport(userID:String,itemtype:String)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose a reason for reporting this user:", preferredStyle: .actionSheet)
        
        let spam = UIAlertAction(title: "Posting inappropriate posts", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.reporting(message: "Posting inappropriate posts", userID: userID, itemtype: itemtype)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        let inappropriate = UIAlertAction(title: "Fake account", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.reporting(message: "Fake account", userID: userID, itemtype: itemtype)
        })
        
        let harasing = UIAlertAction(title: "Bulling or harassing", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.reporting(message: "Bulling or harassing", userID: userID, itemtype: itemtype)
        })
        
        
        optionMenu.addAction(spam)
        optionMenu.addAction(harasing)
        optionMenu.addAction(inappropriate)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func reporting(message:String,userID:String,itemtype:String)
    {
        let dict = ["itemid":userID, "itemtype":"user","message":message,"application_id":app_id,"application_secret":app_secret_key]
        
        comman.showLoader(toView: self)
        
        web_services.badlee_post_with_param(param:dict as NSDictionary,page_url: "report.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            self.showToast(message: "Post has been reported")
            comman.hideLoader(toView: self)
            
        }) { (dara) in
            
            self.showToast(message: "You have already reported this post")
            comman.hideLoader(toView: self)
        }
    }
}
