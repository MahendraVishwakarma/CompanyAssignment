//
//  userProfile.swift
//  Badlee
//
//  Created by Mahendra on 04/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class userProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout 
{

    @IBOutlet weak var btnLendandBorrow: UIButton!
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var showBlockedMessageView: UIView!
    @IBOutlet weak var viewCons: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var btnInterestedIN: UIButton!
    @IBOutlet weak var btnunblock: UIButton!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var purposeViewCons: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblSelector: UILabel!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var headerUserNAme: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnFollowers: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionCons: NSLayoutConstraint!
    var userID:String!
    var str_username:String!
    @IBOutlet weak var trendingImage: UIImageView!
    
    @IBOutlet weak var scrollContainer: UIScrollView!
    // var isLareadyAdded = false
    var userInfo = NSDictionary()
    var purposeData = NSArray()
    var userPosts:NSArray!
    var user_id : String!
    var isIBlocked :Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        btnAdd.layer.cornerRadius = 17.5
        btnAdd.layer.borderColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1).cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.masksToBounds = true
        
        profile_pic.layer.borderColor = UIColor.gray.cgColor
        profile_pic.layer.borderWidth = 0.5
        
        btnunblock.layer.cornerRadius = 25
        btnunblock.layer.masksToBounds = true
        
        btnMessage.layer.cornerRadius = 17.5
        btnMessage.layer.borderColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1).cgColor
        btnMessage.layer.borderWidth = 1
        btnMessage.layer.masksToBounds = true
        
        showBlockedMessageView.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.btnLend_borrow(btnLendandBorrow)
        self.setPermissionAccess()
        self.getUserInfo(userID: userID)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: collectionview datasource & delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width/3 - 15/2, height: UIScreen.main.bounds.width/3 - 15/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purposeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landborrowCell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(210) as! UILabel
        
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = true
        
        let str_url = StaticURLs.base_url + ((purposeData[indexPath.row] as! NSDictionary).object(forKey: "media") as? String ?? "")
        let url = URL.init(string: str_url)
        let gradientLayer = CAGradientLayer(point: .center)
        img.layer.addSublayer(gradientLayer)
        
        let post_type = (purposeData[indexPath.row] as! NSDictionary).object(forKey: "shout_type") as? String ?? ""
        
        if(post_type == "media" && url != nil)
        {
            img.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            img.image = nil
            img.setImageWith(url!, placeholderImage: nil)
            title.isHidden = true
            
        }else{
             title.isHidden = false
            let titleDescription = (purposeData[indexPath.row] as! NSDictionary).object(forKey: "title") as? String ?? ""
            gradientLayer.frame = img.bounds
            title.text = titleDescription
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let post_id = (purposeData[(indexPath.row)] as! NSDictionary).object(forKey: "id") as! Int
        let object_itemDescription = strbrd.instantiateViewController(withIdentifier: "singlePage") as! singlePage
        object_itemDescription.post_id = post_id
        self.present(object_itemDescription, animated: true, completion: nil)
        
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMessage(_ sender: Any)
    {
        let object = storyboard?.instantiateViewController(withIdentifier: "messangerVC") as! messangerVC
        print(userInfo)
        object.reciever_userID = userInfo.object(forKey: "user_id") as? String ?? ""
        self.present(object, animated: true, completion: nil)
        
    }
    
    func getUserInfo(userID:String)
    {
        comman.showLoader(toView: self)
        
       
        let page_url = "user.php?userid=" + userID
       
        web_services.badlee_post_without_auth(page_url: page_url, succuss: { (data) in
            
            self.userInfo = data as! NSDictionary
            //comman.user_info = self.userInfo
            
            self.setUserInfoData(data: self.userInfo)
            self.setPermissionAccess()
            comman.hideLoader(toView: self)
            
        }) { (data) in
            
            self.showToast(message: "User not found")
            self.dismiss(animated: true, completion: nil)
            comman.hideLoader(toView: self)
            
        }
        user_id = userID
        self.getUSerPost(userID: userID,purpose_id: "1")
        
    }
    
    @IBAction func btnInteerestedIN(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "interestedIN") as! interestedIN
        let str_interested =  userInfo.object(forKey: "interests")  as! String
        if(str_interested.count > 0)
        {
            object.arrItems = str_interested.components(separatedBy: ",") as NSArray
        }
        else
        {
            object.arrItems = []
        }
        
        self.present(object, animated: true, completion: nil)
    }
    @IBAction func btnFollowers(_ sender: Any)
    {
        let object = storyboard?.instantiateViewController(withIdentifier: "followers_following") as! followers_following
        object.userData = self.userInfo.object(forKey: "follower") as! NSArray
        object.userType = "Follower users"
       //  self.navigationController?.pushViewController(object, animated: true)
        self.present(object, animated: true, completion: nil)
    }
    @IBAction func btnFollowing(_ sender: Any)
    {
        let object = storyboard?.instantiateViewController(withIdentifier: "followers_following") as! followers_following
        object.userData = self.userInfo.object(forKey: "following") as! NSArray
        object.userType = "Following users"
         //self.navigationController?.pushViewController(object, animated: true)
        self.present(object, animated: true, completion: nil)
        
    }
    
    func setUserInfoData(data:NSDictionary)
    {
        let str_url         =  StaticURLs.base_url + (data.object(forKey: "avatar") as? String ?? "")
        let user_headerName =  data.object(forKey: "username") as! String
        
        self.headerUserNAme.isHidden = true
        self.userName.text = "@"+user_headerName
        if (data.object(forKey: "tickmark") as? String) == "1"{
            trendingImage.image = UIImage(named: "verified_badlee")
        }
        self.userID = data.object(forKey: "user_id") as? String ?? ""
        
        let str_interested  =  data.object(forKey: "interests")  as? String ?? ""
        let arrFollowers    =  data.object(forKey: "follower")  as? NSArray ?? []
        let arrFollowing    =  data.object(forKey: "following") as? NSArray ?? []
        let str_location    =  comman.getCityName(name: data.object(forKey: "location")! as! String)
        let location_gender = (data.object(forKey: "gender") as! String) + " | " + str_location
       // location.text       = location_gender
        let str_username    = (data.object(forKey: "fname") as! String) + " " + (data.object(forKey: "lname") as! String)
        let url = URL.init(string: str_url)
         if data.object(forKey: "tickmark") != nil && (data.object(forKey: "tickmark") as? Int) == 1{
        trendingImage.image = UIImage(named: "verified_badlee")
         }
        
        let attributedStringColor = [NSAttributedStringKey.foregroundColor : UIColor.darkGray];
        let attr_fo = [NSAttributedStringKey.foregroundColor : AppColor.themeColor];
        let att_gender = NSAttributedString(string: location_gender, attributes: attributedStringColor)
        
        let seprate = NSAttributedString(string: " - ", attributes: attr_fo)
        
        let full_name =  NSMutableAttributedString.init(string: str_username)
        full_name.append(seprate)
        full_name.append(att_gender)
        
        
        headerUserNAme.text = user_headerName
        if(url != nil)
        {
            profile_pic.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
       
       // let total_interest = comman.getCategoryName(ids: str_interested)
        let arrInterests = str_interested.components(separatedBy: ",")
        btnInterestedIN.setTitle("\(arrInterests.count)", for: .normal)
        
        
        //interestedIN.text = total_interest
        fullname.attributedText = full_name
        btnFollowing.setTitle("\(arrFollowing.count)", for: .normal)
        btnFollowers.setTitle("\(arrFollowers.count)", for: .normal)
        
        let isLareadyAdded = comman.isAdded(user_id: user_id)
       
        btnAdd.setTitle(isLareadyAdded, for: .normal)
        
        if(isLareadyAdded == "ADD")
        {
            btnAdd.backgroundColor = UIColor.white
            btnAdd.setImage(UIImage.init(named: "community_small"), for: .normal)
            btnAdd.setTitleColor(AppColor.themeColor, for: .normal)
        }
        else
        {
            btnAdd.backgroundColor = AppColor.themeColor
            btnAdd.setTitleColor(UIColor.white, for: .normal)
            btnAdd.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
        }
        
       // let height_interest  = (total_interest.height(withConstrainedWidth: UIScreen.main.bounds.width - 16, font: UIFont.init(name: "Muli-Regular", size: 15)!).height)
        //viewCons.constant = 329 + height_interest
       // purposeViewCons.constant = 282
        
        
    }

    @IBAction func btnAddAction(_ sender: UIButton)
    {
        let user_id = self.userInfo.object(forKey: "user_id") as? String ?? ""
        let page_url = "follow.php?userid=" + user_id
      let isLareadyAdded = comman.isAdded(user_id: user_id)
        
        if(isLareadyAdded == "ADDED")
        {
            let alert = UIAlertController(title: "Badlee", message: "Do you want to unfollow the user?", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK : UIAlertAction = UIAlertAction(title: "YES", style: .default) { (alt) in
               
                self.btnAdd.backgroundColor = UIColor.white
                self.btnAdd.setImage(UIImage.init(named: "community_small"), for: .normal)
                self.btnAdd.setTitle("ADD", for: .normal)
                self.btnAdd.setTitleColor(AppColor.themeColor, for: .normal)
                sender.setTitle("ADD", for: .normal)
                
               // comman.showLoader(toView: self)
                web_services.badlee_delete_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    self.btnAdd.backgroundColor = UIColor.white
                    self.btnAdd.setImage(UIImage.init(named: "community_small"), for: .normal)
                    self.btnAdd.setTitle("ADD", for: .normal)
                    self.btnAdd.setTitleColor(AppColor.themeColor, for: .normal)
                    sender.setTitle("ADD", for: .normal)
                    comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                    comman.hideLoader(toView: self)
                    
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
           // comman.showLoader(toView: self)
            self.btnAdd.backgroundColor = AppColor.themeColor
            self.btnAdd.setTitleColor(UIColor.white, for: .normal)
            self.btnAdd.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
            self.btnAdd.setTitle("ADDED", for: .normal)
            
            web_services.badlee_post_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                
                    self.btnAdd.backgroundColor = AppColor.themeColor
                    self.btnAdd.setTitleColor(UIColor.white, for: .normal)
                    self.btnAdd.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
                    self.btnAdd.setTitle("ADDED", for: .normal)
               
                   comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                   comman.hideLoader(toView: self)
            }, failure: { (data) in
                   comman.hideLoader(toView: self)
            })
        }
        
    }
    
    @IBAction func btnLend_borrow(_ sender: UIButton)
    {
        self.getUSerPost(userID: userID, purpose_id: "1")
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:self.lblSelector.frame.origin.y,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
            self.lblSelector.backgroundColor = UIColor.init(red: 131.0/255.0, green: 205.0/255.0, blue: 68.0/255.0, alpha: 1)
            
        }
        
    }
    
    @IBAction func shout(_ sender: UIButton)
    {
        self.getUSerPost(userID: user_id, purpose_id: "3")
        
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:self.lblSelector.frame.origin.y,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
             self.lblSelector.backgroundColor = UIColor.init(red: 36.0/255.0, green: 136.0/255.0, blue: 233.0/255.0, alpha: 1)
        }
    }
    @IBAction func btnShowOff(_ sender: UIButton)
    {
        self.getUSerPost(userID: user_id, purpose_id: "2")
        
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:self.lblSelector.frame.origin.y,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
            self.lblSelector.backgroundColor = UIColor.init(red: 244.0/255.0, green: 233.0/255.0, blue: 0.0/255.0, alpha: 1)
            
        }
    }
    @IBAction func btnWish(_ sender: UIButton)
    {
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        //
        
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:self.lblSelector.frame.origin.y,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
             self.lblSelector.backgroundColor = UIColor.init(red: 255.0/255.0, green: 65.0/255.0, blue: 68.0/255.0, alpha: 1)
        }
        
        let page_url = "wish.php?userid=" + user_id + "&limit=20&offset=0"
        
        web_services.badlee_get_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            self.purposeData = data as! NSArray
            self.collectionview.reloadData()
            self.collectionview.layoutIfNeeded()
            print(self.collectionview.contentSize.height)
            if(self.collectionview.contentSize.height >= UIScreen.main.bounds.height-64){
                self.collectionCons.constant =  ( self.view.frame.height - 50 - (self.tabBarController?.tabBar.frame.height)! - 64 - self.view.safeAreaInsets.top)
                
            }else{
                self.collectionCons.constant = self.collectionview.contentSize.height
            }
           // self.collectionview.updateConstraints()
           // self.scrollContainer.layoutIfNeeded()
            print( self.collectionCons.constant)
            
            // print(data)
            
        }) { (data) in
            
          //  self.showToast(message: "something went wrong")
            self.purposeData = []
            self.collectionview.reloadData()
            self.collectionview.layoutIfNeeded()
            if(self.collectionview.contentSize.height >= UIScreen.main.bounds.height-64){
                self.collectionCons.constant =  ( self.view.frame.height - 50 - (self.tabBarController?.tabBar.frame.height)! - 64 - self.view.safeAreaInsets.top)
                
            }else{
                self.collectionCons.constant = self.collectionview.contentSize.height
            }
            print( self.collectionCons.constant)
            
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    func getUSerPost(userID:String,purpose_id:String)
    {
       
        let page_url = "posts.php?userid=" + userID + "&offset=0&limit=100&purpose=" + purpose_id
        
        web_services.badlee_get(page_url: page_url, isFuckingKey: true, success: { (data) in
            
            DispatchQueue.main.async
                {
                    
                    self.purposeData = data as! NSArray
                    self.collectionview.reloadData()
                    self.collectionview.layoutIfNeeded()
                    if(self.collectionview.contentSize.height >= UIScreen.main.bounds.height-64){
                        self.collectionCons.constant =  ( self.view.frame.height - 50 - (self.tabBarController?.tabBar.frame.height)! - 64 - self.view.safeAreaInsets.top)
                        
                    }else{
                        self.collectionCons.constant = self.collectionview.contentSize.height
                    }
                    print( self.collectionCons.constant)
                    
                    
            }
            
           // print(data)
            
        }) { (data) in
            
            //self.showToast(message: "something went wrong")
            self.purposeData = []
            self.collectionview.reloadData()
            self.collectionview.layoutIfNeeded()
            if(self.collectionview.contentSize.height >= UIScreen.main.bounds.height-64){
                self.collectionCons.constant =  ( self.view.frame.height - 50 - (self.tabBarController?.tabBar.frame.height)! - 64 - self.view.safeAreaInsets.top)
                
            }else{
                self.collectionCons.constant = self.collectionview.contentSize.height
            }
            print( self.collectionCons.constant)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        

    }
    

    
    @IBAction func btnMenu(_ sender: Any)
    {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        let block_msg = isIBlocked == true ? "Unblock User" : "Block User"
        
        
        let block_user = UIAlertAction(title: block_msg, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if(self.isIBlocked)
            {
                self.unblockthisUser()
            }
            else
            {
                let user_id = self.userInfo.object(forKey: "user_id") as! String
                comman.showLoader(toView: self)
                web_services.badlee_post_with_authentication(page_url: "block.php?userid=\(user_id)", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                    print(data!)
                    self.isIBlocked = true
                    self.setPermissionAccess()
                    self.showToast(message: "User has been blocked")
                    comman.hideLoader(toView: self)
                    
                    
                }, failure: { (error) in
                    
                    comman.hideLoader(toView: self)
                })
            }
            
        })
        
        let report_user = UIAlertAction(title: "Report User", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.doReport(itemtype: "user")
           
        })
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        optionMenu.addAction(block_user)
        optionMenu.addAction(report_user)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func doReport(itemtype:String)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose a reason for reporting this user:", preferredStyle: .actionSheet)
        
        let spam = UIAlertAction(title: "Posting inappropriate posts", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.reporting(message: "Posting inappropriate posts", itemtype: itemtype)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        let inappropriate = UIAlertAction(title: "Fake account", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.reporting(message: "Fake account", itemtype: itemtype)
        })
        
        let harasing = UIAlertAction(title: "Bulling or harassing", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.reporting(message: "Bulling or harassing", itemtype: itemtype)
        })
        
        
        optionMenu.addAction(spam)
        optionMenu.addAction(harasing)
        optionMenu.addAction(inappropriate)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func reporting(message:String,itemtype:String)
    {
        let dict = ["itemid":user_id, "itemtype":itemtype,"message":message,"application_id":app_id,"application_secret":app_secret_key]
        
        comman.showLoader(toView: self)
        
        web_services.badlee_post_with_param(param:dict as NSDictionary,page_url: "report.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            self.showToast(message: "User has been reported")
            comman.hideLoader(toView: self)
            
        }) { (dara) in
            
            self.showToast(message: "You have already reported this user")
            comman.hideLoader(toView: self)
        }
    }
    @IBAction func btnUnBlockeUSer(_ sender: Any)
    {
        self.unblockthisUser()
    }
    
    func setPermissionAccess()
    {
        
        if(isIBlocked)
        {
                btnAdd.isEnabled = false
                btnMessage.isEnabled = false
                showBlockedMessageView.isHidden = false
        }
        else
        {
            btnAdd.isEnabled = true
            btnMessage.isEnabled = true
            showBlockedMessageView.isHidden = true
        }
       
    }
    
    
    func unblockthisUser()
    {
        let user_id = self.userInfo.object(forKey: "user_id") as! String
        
        comman.showLoader(toView: self)
        web_services.badlee_delete_with_authentication(page_url: "block.php?userid=\(user_id)", username: appDel.loginUserInfo.username!, password:
            
            appDel.loginUserInfo.password!, success: { (data) in
                print(data!)
                 comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                self.showToast(message: "User has been unblocked")
                comman.hideLoader(toView: self)
                self.isIBlocked = false
                self.getUserInfo(userID: user_id)
                
        }) { (error) in
            
            comman.hideLoader(toView: self)
        }
    }
    
    @IBAction func btnShowImage(_ sender: Any)
    {
        
            let object = self.storyboard?.instantiateViewController(withIdentifier: "zoomImage") as! zoomImage
            
            object.imageSelected = profile_pic.image
            
            object.modalPresentationStyle = .overCurrentContext
            
            self.present(object, animated: false, completion: nil)
        }
        
    
    
}
