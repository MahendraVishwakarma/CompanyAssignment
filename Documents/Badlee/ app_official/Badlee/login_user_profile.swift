

import UIKit

class login_user_profile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var gender_location: UILabel!
    @IBOutlet weak var btnLendandBorrow: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var purposeViewCons: NSLayoutConstraint!
    @IBOutlet weak var lblprofilename: UILabel!
    @IBOutlet weak var lblSelector: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewCons: NSLayoutConstraint!
    @IBOutlet weak var interest: UILabel!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var collection_cons: NSLayoutConstraint!
    @IBOutlet weak var collectionLandBorrow: UICollectionView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var btnFollowers: UIButton!
    @IBOutlet weak var img_profile: UIImageView!
    var userInfo = NSDictionary()
    var purposeData = NSArray()
    var userPosts:NSArray!
    var selected_postitem = ""
    @IBOutlet weak var trendingImage: UIImageView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var bannerLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        img_profile.layer.borderColor = UIColor.gray.cgColor
        img_profile.layer.borderWidth = 0.5
        bannerView.isHidden = true
        btnPost.layer.cornerRadius = 10
        btnPost.layer.borderWidth = 0.8
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
      
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.btnlend_borrow(btnLendandBorrow)
        self.getUserInfo(userID: appDel.loginUserInfo.user_id!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo(userID:String)
    {
        comman.showLoader(toView: self)
        let page_url = "user.php?userid=" + appDel.loginUserInfo.user_id!;        web_services.badlee_post_without_auth(page_url: page_url, succuss: { (data) in
            
            self.userInfo = data as! NSDictionary
            comman.user_info = self.userInfo
            self.setUserInfoData(data: self.userInfo)
            comman.hideLoader(toView: self)
            
        }) { (data) in
            
            self.showToast(message: "You've been logged out.")
            comman.showLoader(toView: self)
            
            web_services.badlee_post_with_authentication(page_url: "logout.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                comman.hideLoader(toView: self)
                self.logoutuser()
                
            }, failure: { (err) in
                self.logoutuser()
                comman.hideLoader(toView: self)
            })
            
            comman.hideLoader(toView: self)
            
        }
        
        self.getUSerPost(userID: userID,purpose_id: "1")
    }
    
    func setUserInfoData(data:NSDictionary)
    {
        let str_url =     StaticURLs.base_url +  ( data.object(forKey: "avatar") as? String ?? "")
        
        let user_headerName = data.object(forKey: "username") as! String
        let str_interested =  data.object(forKey: "interests")  as! String
        let arrFollowers =    data.object(forKey: "follower")  as? NSArray ?? []
        let arrFollowing =    data.object(forKey: "following") as? NSArray ?? []
        let str_location =    comman.getCityName(name: data.object(forKey: "location")! as! String)
        let location_gender = (data.object(forKey: "gender") as! String) + " | " + str_location
       
        if (data.object(forKey: "tickmark") as? String) == "1"{
            trendingImage.image = UIImage(named: "verified_badlee")
        }
        
        let str_username =  (data.object(forKey: "fname") as! String) + " " + (data.object(forKey: "lname") as! String)
        
        lblprofilename.text = "@" + user_headerName
        let attributedStringColor = [NSAttributedStringKey.foregroundColor : UIColor.darkGray];
        let attr_fo = [NSAttributedStringKey.foregroundColor : AppColor.themeColor];
        let att_gender = NSAttributedString(string: location_gender, attributes: attributedStringColor)
        
         let seprate = NSAttributedString(string: " - ", attributes: attr_fo)
        
        let full_name =  NSMutableAttributedString.init(string: str_username)
        full_name.append(seprate)
        full_name.append(att_gender)
        
        
        let url = URL.init(string: str_url)
       
        if(url != nil)
        {
            img_profile.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        
      //  let total_interest = comman.getCategoryName(ids: str_interested)

        let arrInterests = str_interested.components(separatedBy: ",")
        btnInterestedIN.setTitle("\(arrInterests.count)", for: .normal)
        
       // interest.text = total_interest
        username.attributedText = full_name
        btnFollowing.setTitle("\(arrFollowing.count)", for: .normal)
        btnFollowers.setTitle("\(arrFollowers.count)", for: .normal)
        
        let login_userid = appDel.loginUserInfo.user_id

        
        for dict in arrFollowers {
            
            let user_id = (dict as! NSDictionary).object(forKey: "user_id_follower") as! String
            
            if(user_id == login_userid)
            {
                
                break
            }
        }
        
      

    }
    

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
        
        let str_url = StaticURLs.base_url + (((purposeData[indexPath.row] as! NSDictionary).object(forKey: "thumb") as? NSDictionary)?.object(forKey: "mini") as? String ?? "")
        
       // let str_url = base_url + ((purposeData[indexPath.row] as! NSDictionary).object(forKey: "media") as? String ?? "")
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
    
   
    
    @IBAction func btnFollowing(_ sender: Any)
    {
        let object = storyboard?.instantiateViewController(withIdentifier: "followers_following") as! followers_following
        //
        object.userData = self.userInfo.object(forKey: "following") as? NSArray ?? []
        object.userType = "Following users"
        //self.navigationController?.pushViewController(object, animated: true)
        self.present(object, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var btnInterestedIN: UIButton!
    @IBAction func btnInterestedIN(_ sender: Any)
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
        object.userData = self.userInfo.object(forKey: "follower") as? NSArray ?? []
        object.userType = "Follower users"
         //self.navigationController?.pushViewController(object, animated: true)
        self.present(object, animated: true, completion: nil)
        
    }
     func setScrollviewContentSize()
    {
        if(self.purposeData.count <= 0){
            self.bannerView.isHidden = false
        }else{
            self.bannerView.isHidden = true
        }
         self.collectionLandBorrow.reloadData()
         self.collectionLandBorrow.layoutIfNeeded()
        
        print(self.collectionLandBorrow.contentSize.height)
        if(self.collectionLandBorrow.contentSize.height >= UIScreen.main.bounds.height-64){
            self.collection_cons.constant =  ( self.view.frame.height - 50 - (self.tabBarController?.tabBar.frame.height)! - 64)
            
        }else{
            self.collection_cons.constant = self.collectionLandBorrow.contentSize.height
        }
        
    }
    
    func getUSerPost(userID:String,purpose_id:String)
    {
        
        let page_url = "posts.php?userid=" + userID + "&offset=0&limit=100&purpose=" + purpose_id
        
        web_services.badlee_get(page_url: page_url, isFuckingKey: true, success: { (data) in
            
            DispatchQueue.main.async
                {
                    
                self.purposeData = data as! NSArray
               
                self.setScrollviewContentSize()
                print( self.collection_cons.constant)
        
                }
            // print(data)
            
        }) { (data) in
            
            DispatchQueue.main.async {
                self.purposeData = []
                
                self.setScrollviewContentSize()
                
                
            }
          
          //  self.showToast(message: "something went wrong")
        }
        
    }
    @IBAction func btnlend_borrow(_ sender: UIButton)
    {
        self.getUSerPost(userID: appDel.loginUserInfo.user_id!, purpose_id: "1")
        
        btnPost.layer.borderColor = UIColor.init(red: 131.0/255.0, green: 205.0/255.0, blue: 68.0/255.0, alpha: 1).cgColor
        self.changeBannerLabelText(message: "LEND")
        btnPost.accessibilityIdentifier = "lend_borrow"
        btnPost.setTitle(" ADD A THING FOR LEND ", for: .normal)
        
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:sender.frame.maxY + 8,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
             self.lblSelector.backgroundColor = UIColor.init(red: 131.0/255.0, green: 205.0/255.0, blue: 68.0/255.0, alpha: 1)
            
        }
        
    }
    @IBAction func btnShowOff(_ sender: UIButton)
    {
        self.getUSerPost(userID: appDel.loginUserInfo.user_id!, purpose_id: "2")
        btnPost.layer.borderColor =  UIColor.init(red: 244.0/255.0, green: 233.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
        btnPost.setTitle("ADD A THING FOR SHOW OFF", for: .normal)
        self.changeBannerLabelText(message: "SHOW OFF")
        btnPost.accessibilityIdentifier = "showoff"
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:sender.frame.maxY + 8,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
            self.lblSelector.backgroundColor = UIColor.init(red: 244.0/255.0, green: 233.0/255.0, blue: 0.0/255.0, alpha: 1)
            
        }
        
    }
    
    @IBAction func btnShout(_ sender: UIButton)
    {
        self.getUSerPost(userID: appDel.loginUserInfo.user_id!, purpose_id: "3")
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        btnPost.layer.borderColor =  UIColor.init(red: 36.0/255.0, green: 136.0/255.0, blue: 233.0/255.0, alpha: 1).cgColor
        btnPost.setTitle("ADD A THING FOR BORROW", for: .normal)
        btnPost.accessibilityIdentifier = "shout"
        self.changeBannerLabelText(message: "BORROW")
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:sender.frame.maxY + 8,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
            self.lblSelector.backgroundColor = UIColor.init(red: 36.0/255.0, green: 136.0/255.0, blue: 233.0/255.0, alpha: 1)
            
        }
        
    }
    
    @IBAction func btnWish(_ sender: UIButton)
    {
       // self.getUSerPost(userID: appDel.loginUserInfo.user_id!, purpose_id: "3")
        let cen = sender.frame.origin.x + sender.frame.width/2
        let origin = cen - lblSelector.frame.width/2
        //bannerView.isHidden = true
        btnPost.layer.borderColor =  UIColor.init(red: 255.0/255.0, green: 65.0/255.0, blue: 68.0/255.0, alpha: 1).cgColor
        btnPost.setTitle("EXPLORE SOME THINGS", for: .normal)
        self.changeBannerLabelText(message: "WISH LIST")
        btnPost.accessibilityIdentifier = "wish"
        
        UIView.animate(withDuration: 0.4)
        {
            self.lblSelector.frame = CGRect(x:origin,y:sender.frame.maxY + 8,width:self.lblSelector.frame.width, height:self.lblSelector.frame.height)
             self.lblSelector.backgroundColor = UIColor.init(red: 255.0/255.0, green: 65.0/255.0, blue: 68.0/255.0, alpha: 1)
        }
        
        let page_url = "wish.php?userid=" + appDel.loginUserInfo.user_id! + "&limit=20&offset=0"

        web_services.badlee_get_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in

            DispatchQueue.main.async
                {
                    self.purposeData = data as! NSArray
        
                    self.setScrollviewContentSize()
                   
            }


        }) { (data) in

            DispatchQueue.main.async
                {

                    DispatchQueue.main.async {
                        self.purposeData = []
                        
                        self.setScrollviewContentSize()
                       
                    }

            }
        }
       

    }
    
    @IBAction func btnActionMenu(_ sender: Any)
    {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let tc = UIAlertAction(title: "See T&C", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let object = self.storyboard?.instantiateViewController(withIdentifier: "term_condition") as! term_condition
            self.present(object, animated: true, completion: nil)
            
        })
        
        let change_profile = UIAlertAction(title: "Change Password", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let object = self.storyboard?.instantiateViewController(withIdentifier: "change_password") as! change_password
            object.modalPresentationStyle = .overCurrentContext
            object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.present(object, animated: true, completion: nil)
        })
        
        let edit_profile = UIAlertAction(title: "Edit Profile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let object = self.storyboard?.instantiateViewController(withIdentifier: "edit_profile") as! edit_profile
            object.userInfo = self.userInfo
            self.present(object, animated: true, completion: nil)
        })
        
        let blockedUsers = UIAlertAction(title: "Blocked Users", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
           
            self.blockedUsers()
            
        })
        
        let logout = UIAlertAction(title: "Logout", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
           self.logout()
           
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(tc)
        optionMenu.addAction(change_profile)
        optionMenu.addAction(edit_profile)
        optionMenu.addAction(blockedUsers)
        optionMenu.addAction(logout)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)

    }
    func logout()
    {
        let optionMenu = UIAlertController(title: "Logout", message: "Do you want logout?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "YES", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            comman.showLoader(toView: self)
            
            web_services.badlee_post_with_authentication(page_url: "logout.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                comman.hideLoader(toView: self)
               self.logoutuser()
                
            }, failure: { (err) in
                 self.logoutuser()
                 comman.hideLoader(toView: self)
            })
            
        })
        
        let no = UIAlertAction(title: "NO", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        
        optionMenu.addAction(no)
        optionMenu.addAction(yes)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func logoutuser()
    {
        let dict :NSDictionary = ["user_id": "","user_name":"","isLogin": 0,"first_name":"","last_name":"","gender":"","birthday":"","city_id":"","interested":"","email":""]
        
        loginManager.setUserLogin(dict: dict)
        appDel.loginUserInfo.username = nil
        appDel.loginUserInfo.password = nil
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "logoutMessageVC") as! logoutMessageVC
        self.present(object, animated: true, completion: nil)
        
    }
    
    func blockedUsers()
    {
        let strboard = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strboard.instantiateViewController(withIdentifier: "blockedUserList") as! blockedUserList
        object.userList.addObjects(from: ((userInfo.object(forKey: "i_block") as? NSArray ?? [])) as! [Any])
        
        self.present(object, animated: true, completion: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func btnAddUser(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "suggestedUser") as! suggestedUser
        self.present(object, animated: true, completion: nil)
        
    }
    
    @IBAction func btnShowIMage(_ sender: Any)
    {
        let object = self.storyboard?.instantiateViewController(withIdentifier: "zoomImage") as! zoomImage
        
        object.imageSelected = img_profile.image
        
        object.modalPresentationStyle = .overCurrentContext
        
        self.present(object, animated: false, completion: nil)
    }
    
    @IBAction func btnPOstItems(_ sender: Any)
    {
        if(btnPost.accessibilityIdentifier == "wish"){
            self.tabBarController?.selectedIndex = 2
        }else{
             self.floatingActions(actiontype: btnPost.accessibilityIdentifier ?? "")
        }
       
    }
    
    func changeBannerLabelText(message:String){
         let fullText = "Your \(message) shelf seems empty"
        let range = (fullText as NSString).range(of: message)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "Muli-Bold", size: 15) ?? "", range: range)
        bannerLabel.attributedText = attributedString
    }
    
    func floatingActions(actiontype:String)
    {
        let pickerController = UIImagePickerController()
        if(actiontype == "lend_borrow")
        {
            selected_postitem = "lendandborrow prof pic 1x"
        }
        else if(actiontype == "shout")
        {
            selected_postitem = "shout profile pic 1x"
        }
        else if(actiontype == "showoff")
        {
            selected_postitem = "show off 1x"
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Choose resource to take photo", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.camera
                pickerController.allowsEditing = false
                
                self.present(pickerController, animated: true, completion: nil)
            }
            
        })
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                pickerController.allowsEditing = false
                self.present(pickerController, animated: true, completion: nil)
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(camera)
        optionMenu.addAction(gallery)
        optionMenu.addAction(cancel)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage).fixOrientation()
        
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object_postitem = strbrd.instantiateViewController(withIdentifier: "imageOrientationVC") as! imageOrientationVC
        object_postitem.selected_imagename = selected_postitem
        object_postitem.img_selected = image
        object_postitem.homeObject = self
        dismiss(animated:true, completion: nil)
        self.navigationController?.pushViewController(object_postitem, animated: true)
        
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated:true, completion: nil)
    }
   
    
}
