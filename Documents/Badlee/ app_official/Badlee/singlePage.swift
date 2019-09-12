//

//

import UIKit
import CoreLocation



class singlePage: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{

    @IBOutlet weak var constraintHeightWMsg: NSLayoutConstraint!
    @IBOutlet weak var imgHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tableview_height: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomMsgType: NSLayoutConstraint!
    @IBOutlet weak var height_contraight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var hashtag_view: UIView!
    @IBOutlet weak var lnlDistance: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var container_view_cons: NSLayoutConstraint!
    @IBOutlet weak var btnreaction: UIButton!
    @IBOutlet weak var btnwish: UIButton!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var itemPIc: UIImageView!
    @IBOutlet weak var location_name: UILabel!
    @IBOutlet weak var item_description: UILabel!
    @IBOutlet weak var view_comments: UIView!
    let placeHolder = "Comments..."
    var search_object: hashtagVC!
    var post_id:Int!
    var post_data = NSDictionary()
    var arrComments = NSMutableArray()
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var item_reaction: UIImageView!
    var lat:Double = 0.0
    var long:Double = 0.0
    @IBOutlet weak var titleMessage: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(navigationVC.sharedInstance.lat!, navigationVC.sharedInstance.long!)
        lat = coordinate.latitude
        long = coordinate.longitude

        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:0.4)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        headerView.layer.masksToBounds = false
        userPic.layer.cornerRadius = userPic.frame.height/2
        userPic.layer.masksToBounds = true
        
        commentView.text = placeHolder
        commentView.textColor = UIColor.lightGray
        
        view_comments.layer.cornerRadius = view_comments.frame.height/2
        view_comments.layer.masksToBounds = true
        view_comments.layer.borderColor = UIColor.gray.cgColor
        view_comments.layer.borderWidth = 0.6
        
        hashtag_view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        hashtag_view.layer.shadowOffset = CGSize(width:0.0, height:0.0)
        hashtag_view.layer.shadowOpacity = 1.0
        hashtag_view.layer.shadowRadius = 1
        hashtag_view.layer.masksToBounds = false
        
        commentView.text = placeHolder
        commentView.textColor = UIColor.lightGray
        hashtag_view.isHidden = true
        height_contraight.constant = 0.0
        btnSend.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.isScrollEnabled = false
        
        self.getData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "commentTag")
        {
            let searchObject = segue.destination  as! hashtagVC
            search_object = searchObject
            
        }
    }
    
    
    
    
    //MARK:- text view delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        
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
    
    @IBAction func btnSendMessage(_ sender: Any)
    {
        
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
    
    func tableview_up()
    {
        
        hashtag_view.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            if(self.search_object != nil)
            {
                if(self.search_object.tableview.contentSize.height >= 250)
                {
                    self.height_contraight.constant = 250
                }
                else
                {
                    self.height_contraight.constant = CGFloat(self.search_object.user_child_list.count*60)
                }
            }
            
            
        })
        
        
    }
    func tableview_down()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.height_contraight.constant = 0
            
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:comments!
        if((arrComments[indexPath.row] as! NSDictionary).object(forKey: "user_id") as? String ?? "" == appDel.loginUserInfo.user_id)
        {
            cell = (tableView.dequeueReusableCell(withIdentifier: "cell_my", for: indexPath) as! comments)
            cell.username.text = appDel.loginUserInfo.first_name ?? ""
            let str_url = StaticURLs.base_url + (comman.user_info.object(forKey: "avatar") as? String ?? "")
            let avatar_url = URL.init(string: str_url)
            let img_placeholder = UIImage.init(named: "user pic 1x")
            
            if(avatar_url != nil)
            {
                cell.img_profile.setImageWith(avatar_url!, placeholderImage: img_placeholder)
            }
            
        }
        else
        {
            cell = (tableView.dequeueReusableCell(withIdentifier: "cell_user", for: indexPath) as! comments)
            cell.username.text = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "fname") as? String ?? ""
            let str_url = StaticURLs.base_url + ((arrComments[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? "")
            let avatar_url = URL.init(string: str_url)
            let img_placeholder = UIImage.init(named: "user pic 1x")
            
            if(avatar_url != nil)
            {
                cell.img_profile.setImageWith(avatar_url!, placeholderImage: img_placeholder)
            }
        }
        
        let btnReport = cell.viewWithTag(10) as! UIButton
        btnReport.addTarget(self, action: #selector(btnReport(_:)), for: .touchUpInside)
        
        let btnReply = cell.viewWithTag(11) as! UIButton
        btnReply.addTarget(self, action: #selector(btnReply(sender:)), for: .touchUpInside)
        
        
        cell.comments.text = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "content") as? String ?? ""
        
        cell.img_profile.layer.cornerRadius = cell.img_profile.frame.height/2
        cell.img_profile.layer.masksToBounds = true
        cell.commentView.layer.cornerRadius = 14
        
        let str_date = (arrComments[indexPath.row] as! NSDictionary).object(forKey: "timestamp") as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let local_date = Date()
        let server_date = dateFormatter.date(from: str_date!)!
        
        let timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
        cell.timing.text = timestamp
        
        
        return cell
    }
    
   
    func getData()
    {
        
        comman.showLoader(toView: self)
        
        web_services.badlee_get(page_url: "posts.php?postid=\(post_id!)&lat=\(lat)&long=\(long)&recstatus=\(appDel.loginUserInfo.user_id!)", isFuckingKey: true, success: { (data) in
          
            comman.hideLoader(toView: self)
            self.post_data = data as! NSDictionary
            print(self.post_data)
            self.setDefualtData()
            
            
        }) { (data) in
            comman.hideLoader(toView: self)
            
        }
        
    }
    
    func setDefualtData()
    {
        
        let img_placeholder = UIImage.init(named: "user pic 1x")
        let str_url = (post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "avatar") as? String ?? ""
        let avatar_url = URL.init(string: StaticURLs.base_url + str_url)
        if(avatar_url != nil)
        {
            userPic.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
        
        let username = (post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "username") as? String ?? ""
        userName.text = username
        item_description.text = post_data.object(forKey: "description") as? String ?? ""
        
        var item_str_url = post_data.object(forKey: "media") as! String
        
        item_str_url = StaticURLs.base_url + item_str_url
        var height:CGFloat  = 10.0
        let item_url = URL.init(string: item_str_url)
        
        let gradientLayer = CAGradientLayer(point: .center)
        itemPIc.layer.addSublayer(gradientLayer)
        
        let post_type = post_data.object(forKey: "shout_type") as? String ?? ""
        
        if(post_type == "media" && item_url != nil)
        {
           
            let ori_type = post_data.object(forKey: "orientation") as? String ?? ""
            itemPIc.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            titleMessage.isHidden = true
            if(ori_type == "portrait")
            {
                height = CGFloat(Double(UIScreen.main.bounds.width*1.14))
            }
            else if(ori_type == "landscape")
            {
                height = CGFloat(Double(UIScreen.main.bounds.width*0.75))
                
            }
            else
            {
                height = 240
            }
            
            imgHeightCons.constant = height
            
            itemPIc.setImageWith(URLRequest.init(url: item_url!), placeholderImage: nil, success: { (req, res, img) in

                self.itemPIc.image = img

            }, failure: nil)
        }else{
            titleMessage.isHidden = false
            let titleDescription = post_data.object(forKey: "title") as? String ?? ""
            gradientLayer.frame = itemPIc.bounds
            titleMessage.text = titleDescription
            imgHeightCons.constant = 240
             height = 240
        }
        
        let str_date = post_data.object(forKey: "timestamp") as? String
        
        lnlDistance.text = post_data.object(forKey: "distance") as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let local_date = Date()
        let server_date = dateFormatter.date(from: str_date!)!
        
        let timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
        
        let city = comman.getCityName(name: (post_data.object(forKey: "location") as? String)!) + " • " + timestamp
        
        
        let range = (city as NSString).range(of: timestamp)
        
        let attributedString = NSMutableAttributedString(string:city)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: range)
        
        location_name.attributedText = attributedString
        
        let reaction_name = post_data.object(forKey: "purpose") as? String
        item_reaction.image = comman.getReaction(reactionName: reaction_name!)
        
        
        var count_likes = NSArray()
        
        if(post_data.object(forKey: "likes") is NSArray)
        {
            count_likes = post_data.object(forKey: "likes") as! NSArray
        }
        

        var count_wishes = NSArray()
        if(post_data.object(forKey: "wish") is NSArray)
        {
            count_wishes = post_data.object(forKey: "wish") as! NSArray

        }

        let total_reaction = Int(count_likes.count) + Int(count_wishes.count)
        
        var reactions = "0"
        if(total_reaction > 1)
        {
            reactions =  "\(total_reaction)" + " reactions"
        }
        else
        {
            reactions =  "\(total_reaction)" + " reaction"
        }
        
        btnreaction.setTitle(reactions, for: .normal)
       // btn.setTitle(comments, for: .normal)
        
        let isLiked = (post_data.object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "like") as? NSString ?? "no"
        
        if(isLiked == "yes")
        {
            
            btnlike.setImage(UIImage.init(named: "like 1x"), for: .normal)
            btnlike.isSelected = true
            btnlike.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
        }
        else
        {
            btnlike.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
            btnlike.isSelected = false
            btnlike.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        let isWished = (post_data.object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "wish") as? NSString ?? "no"
        
        let isHave = (post_data.object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "have") as? NSString ?? "no"
        
        if(reaction_name != "3")
        {
            if( isWished == "no" )
            {
                
                btnwish.setImage(UIImage.init(named: "unwished 1x"), for: .normal)
                btnwish.setTitle("Wish", for: .normal)
                btnwish.setTitleColor(UIColor.darkGray, for: .normal)
                btnwish.isSelected = false
                
            }
            else
            {
                btnwish.setImage(UIImage.init(named: "wish 1x"), for: .normal)
                btnwish.setTitle("Wish", for: .normal)
                btnwish.setTitleColor(UIColor.darkGray, for: .normal)
                btnwish.isSelected = true
            }
            
        }
        else if(reaction_name == "3")
        {
            if( isHave == "no")
            {
                btnwish.setImage(UIImage.init(named: "ihavenot"), for: .normal)
                btnwish.setTitle("Have", for: .normal)
                btnwish.setTitleColor(UIColor.darkGray, for: .normal)
                btnwish.isSelected = false
            }
            else
            {
                btnwish.setImage(UIImage.init(named: "ihave"), for: .normal)
                btnwish.setTitle("Have", for: .normal)
                btnwish.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
                btnwish.isSelected = true
            }
        
        }

        arrComments.addObjects(from: ((post_data.object(forKey: "comments") as? NSArray ?? []) as! [Any]))
        
        self.tableview.reloadData()
        self.scrollview.layoutIfNeeded()
        self.tableview_height.constant = self.tableview.contentSize.height
        height = height + (item_description.text?.height(withConstrainedWidth: 26, font: item_description.font))!
        self.container_view_cons.constant = CGFloat(15 + 226 + height)
       
        //tableview.layoutIfNeeded()
        //scrollview.layoutIfNeeded()
       // self.view.layoutIfNeeded()
        
    
    }
    
    
   

    @IBAction func btnBack(_ sender: Any)
    {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnReply(sender:UIButton)
    {
        commentView.text = nil
        let cell = sender.superview?.superview as? comments
        let indexPath = tableview.indexPath(for: cell!)
        
        var username = ""
        
        if((arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "user_id") as? String ?? "" == appDel.loginUserInfo.user_id)
        {
            username =  "@" + appDel.loginUserInfo.username!
        }
        else
        {
            username = "@" + String(describing: (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "username") as? String ?? "")
        }
        
        self.setup_mention(data: username)
        
    }
    
    
    @IBAction func btnReport(_ sender: UIButton)
    {
        let cell = sender.superview?.superview as? comments
        let indexPath = tableview.indexPath(for: cell!)

        let itemid = (arrComments[(indexPath?.row)!] as! NSDictionary).object(forKey: "comment_id") as! Int
        let itemtype = "comment"
        doReport(itemID: "\(itemid)", itemtype: itemtype)
            
    }
    
    func doShare(sender_name:String,str_description:String,imageURL:String,item_id:String,ownerID:String,post_url:String)
    {
        let object  = self.storyboard?.instantiateViewController(withIdentifier: "Followers") as! Followers
        object.selected_imageURL = imageURL
        object.sender_name = sender_name
        object.item_description = str_description
        object.item_id = item_id
        object.item_url = post_url
        object.item_ownerID = ownerID
        
        self.present(object, animated: true, completion: nil)
    }
    
    func doReport(itemID:String,itemtype:String)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose a reason for reporting this post:", preferredStyle: .actionSheet)
        
        let spam = UIAlertAction(title: "It's spam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.reporting(message: "It's a spam", itemid: itemID, itemtype: itemtype)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        let inappropriate = UIAlertAction(title: "It's inappropriate", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.reporting(message: "It's inappropriate", itemid: itemID, itemtype: itemtype)
        })
        
        
        optionMenu.addAction(spam)
        optionMenu.addAction(inappropriate)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func deletePost(post_id:String)
    {
        web_services.badlee_delete_with_authentication(page_url: "posts.php?postid=\(post_id)", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
            
           
            
        }) { (err) in
            
        }
    }
    
    func reporting(message:String,itemid:String,itemtype:String)
    {
       let dict = ["itemid":itemid, "itemtype":itemtype,"message":message,"application_id":app_id,"application_secret":app_secret_key]
        
        comman.showLoader(toView: self)
        
        web_services.badlee_post_with_param(param:dict as NSDictionary,page_url: "report.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            self.showToast(message: "Report has been accepted")
            comman.hideLoader(toView: self)
            
        }) { (dara) in
            
            self.showToast(message: "Something went wrong")
            comman.hideLoader(toView: self)
        }
        

    }
    
    @IBAction func btnLike(_ sender: UIButton)
    {
//        return
        
        let post_id = post_data.object(forKey: "id") as! Int
        
        let img = UIImage.init(named: "like 1x")
        
        let url = "like.php?postid=" + "\(post_id)"
        
        if(img == sender.imageView?.image)
        {
            //liked
            sender.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
            sender.setTitleColor(UIColor.darkGray, for: .normal)
            
            //  (( self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary).setValue("no", forKey: "like")
            
            let dict = self.post_data
            
            let dict_like = self.post_data.object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            dict_mutLike.setValue("no", forKey: "like")
            
            let dict_mut = NSMutableDictionary(dictionary:dict)
            
            dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
            
            post_data = dict_mut
            
            
            web_services.badlee_delete_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                
                let isUnliked = data?.object(forKey: "status") as! Bool
                if(isUnliked == false)
                {
                    (self.post_data.object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "no"
                }
                
                
            }, failure: { (data) in
                sender.setImage(UIImage.init(named: "like 1x"), for: .normal)
                sender.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
                
                dict_mutLike.setValue("yes", forKey: "like")
                
                let dict_mut = NSMutableDictionary(dictionary:dict)
                
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.post_data = dict_mut
            })
        }
        else
        {
            // not liked
            
            sender.setImage(UIImage.init(named: "like 1x"), for: .normal)
            sender.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
            //  (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "yes"
            
            
            let dict = self.post_data
            let dict_like = post_data.object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            dict_mutLike.setValue("yes", forKey: "like")
            
            let dict_mut = NSMutableDictionary(dictionary:dict)
            
            dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
            
            post_data = dict_mut
            
            web_services.badlee_post_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                
                
                let userID = data?.object(forKey: "userid")
                if(userID != nil)
                {
                    // (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "yes"
                }
                
                
            })
            { (data) in
                sender.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
                sender.setTitleColor(UIColor.darkGray, for: .normal)
                //  (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "no"
                dict_mutLike.setValue("no", forKey: "like")
                
                let dict_mut = NSMutableDictionary(dictionary:dict)
                
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.post_data = dict_mut
            }
        }
    }
    @IBAction func btnWish(_ sender: UIButton)
    {
        //let cell = sender.superview?.superview?.superview as! UITableViewCell
       // let index = communityTable.indexPath(for: cell)
        //let userID = (((arrData[(index?.row)!] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as? String)!
        
        let post_id = post_data.object(forKey: "id") as! Int
        
        let img_wished = UIImage.init(named: "wish 1x")
        //let img_unwished = UIImage.init(named: "unwished 1x")
        
        let reaction_name = post_data.object(forKey: "purpose") as? String
        
        
        if(reaction_name != "3")
        {
            //wished / unwished
            let url = "wish.php?postid=" + "\(post_id)"
            
            let dict = post_data
            
            let dict_like = post_data.object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            
            if(img_wished == sender.imageView?.image)
            {
                
                dict_mutLike.setValue("no", forKey: "wish")
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.post_data = dict_mut
                sender.setImage(UIImage.init(named: "unwished 1x"), for: .normal)
                sender.isSelected = false
                
                web_services.badlee_delete_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    
                }, failure: { (data) in
                    
                    
                })
            }
            else
            {
                dict_mutLike.setValue("yes", forKey: "wish")
                
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.post_data = dict_mut
                sender.setImage(UIImage.init(named: "wish 1x"), for: .normal)
                sender.isSelected = true
                
                web_services.badlee_post_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                    
                }) { (data) in
                    
                    
                }
            }
            
        }
        else
        {
            // have / not have
            
            let  url = "have.php?postid=" + "\(post_id)"
            let dict = self.post_data
            
            let img_have = UIImage.init(named: "ihave")
            let img_havenot = UIImage.init(named: "ihavenot")
            
            let dict_like = self.post_data.object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            
            if(img_havenot == sender.imageView?.image )
            {
                dict_mutLike.setValue("yes", forKey: "have")
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                sender.setImage(img_have, for: .normal)
                self.post_data = dict_mut
                sender.isSelected = true
                
                web_services.badlee_post_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                    
                    
                }) { (data) in
                    
                    
                }
                
            }
            else
            {
                dict_mutLike.setValue("no", forKey: "have")
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                sender.setImage(img_havenot, for: .normal)
                sender.isSelected = false
                self.post_data = dict_mut
                
                web_services.badlee_delete_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    
                }, failure: { (data) in
                    
                    
                })
            }
            
        
        }
        
    }
    
    @IBAction func btnReaction(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object_comments = strbrd.instantiateViewController(withIdentifier: "reactionsVC") as! reactionsVC
        object_comments.reactions = post_data
        self.present(object_comments, animated: true, completion: nil)
    }
    

    @IBAction func btnProfileTapped(_ sender: Any)
    {
        print(comman.user_info)
        let user_Meblocked = comman.user_info.object(forKey: "block_me") as? NSArray ?? []

        let user_Iblocked = comman.user_info.object(forKey: "i_block") as? NSArray ?? []
        
        let MeBlocked = NSPredicate(format: "user_id like %@",appDel.loginUserInfo.user_id!);
        
        let iBlocked = NSPredicate(format: "user_id like %@",(post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as! String);
        
        let isIamBlocked = user_Meblocked.filter { MeBlocked.evaluate(with: $0) };
         print(isIamBlocked)
        
        let isIBlocked = user_Iblocked.filter { iBlocked.evaluate(with: $0) };
        print(isIBlocked)
        
        if(isIamBlocked.count > 0)
        {
            let strboard = UIStoryboard.init(name: "comman", bundle: nil)
            let userObject = strboard.instantiateViewController(withIdentifier: "showBlockMessage") as! showBlockMessage
            self.present(userObject, animated: true, completion: nil)
           return
        }
        
        
        let strboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let userID = (post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as! String
        
        let userObject = strboard.instantiateViewController(withIdentifier: "userProfile") as! userProfile
         userObject.isIBlocked = false
        if(isIBlocked.count > 0)
        {
            userObject.isIBlocked = true
        }
        
        
        if(userID != appDel.loginUserInfo.user_id!)
        {
            userObject.userID = userID
            self.present(userObject, animated: true, completion: nil)
        }
       
       // self.navigationController?.pushViewController(userObject, animated: true)
        
    }
    
    @IBAction func btnSendComment(_ sender: UIButton)
    {
        
        
        if(commentView.text == nil || commentView.text == "Comments..." || Int(commentView.text.trimmingCharacters(in: .whitespaces).count) == 0)
        {
            return
        }
        
        
        let mension_str = self.convert_mensionData(message: commentView.text.trimmingCharacters(in: .whitespaces))
        
        let message = mension_str
        
        let param = ["application_id":app_id,"application_secret":app_secret_key,"postid":post_id,"content":message] as [String : Any]
        
        comman.showLoader(toView: self)
        print(param)
        self.commentView.text = nil
        constraintHeightWMsg.constant = 38
        btnSend.isEnabled = false
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "comment.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            let comments_data = data as! NSDictionary
            
            self.arrComments.add(comments_data)
            self.tableview.reloadData()
            self.commentView.text = nil
            self.settableenfScroll()
            
            //  print(data)
            
            comman.hideLoader(toView: self)
            
        }) { (data) in
            
            // print(data)
            comman.hideLoader(toView: self)
            
        }
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
        
        
        return user_id
    }
    
    func settableenfScroll()
    {
        let index = NSIndexPath.init(item: arrComments.count - 1, section: 0)
        
        if(index.row < arrComments.count && index.row >= 0)
        {
            //tableview.scrollToRow(at: index as IndexPath, at: .bottom, animated: false)
            self.scrollview.setContentOffset(CGPoint(x:0, y:self.scrollview!.frame.height), animated: true)

          //  scrollview.scrollRectToVisible(.zero, animated: true)
            self.view.layoutIfNeeded()
        }
        tableview_height.constant = tableview.contentSize.height
    }
    
    func setup_mention(data:String)
    {
        
        let searchQuery = data
        let message = data + " "
        
        let range = (message as NSString).range(of: searchQuery)
        
        
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-Bold", size: 15) ?? "", range: range)
        
        let  main_message = NSMutableAttributedString.init(attributedString: commentView.attributedText)
        main_message.append(attributedString)
        
        commentView.attributedText = main_message
        
        self.tableview_down()
        
    }
    
    @IBAction func btnAction(_ sender: UIButton)
    {
        //let cell = sender.superview?.superview? as! UITableViewCell
        
      //  let index = tableview.indexPath(for: cell)
        let username = ((post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "username") as? String)!
        let userid = ((post_data.object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as? String)!
        let itemid = post_data.object(forKey: "id") as! Int
        
        let imgURL = post_data.object(forKey: "media") as! String
        
        let itemtype = post_data.object(forKey: "purpose") as? String
        
        let item_description = post_data.object(forKey: "description") as? String
        
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
             self.doShare(sender_name: username,str_description:item_description!,imageURL: imgURL,item_id: "\(itemid)", ownerID: userid, post_url: imgURL )
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        if(username == appDel.loginUserInfo.username)
        {
            
            let delete = UIAlertAction(title: "Delete Post", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.deletePost(post_id: "\(itemid)")
            })
            
            
            optionMenu.addAction(delete)
            
        }
        else
        {
            
            let report = UIAlertAction(title: "Report!", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.doReport(itemID: "\(itemid)", itemtype: itemtype!)
            })
            
            
            optionMenu.addAction(report)
            
        }
        
        optionMenu.addAction(camera)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: Any)
    {
        commentView.resignFirstResponder()
       
    }
}

