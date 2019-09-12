

    import UIKit
    import UserNotifications
    import Floaty


    class itemcell: UITableViewCell
    {
    @IBOutlet weak var btnMoreHeight: NSLayoutConstraint!
    @IBOutlet weak var imgHeightCons: NSLayoutConstraint!
    @IBOutlet weak var img_item: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    }

    class communityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UNUserNotificationCenterDelegate
    {

    private let refreshControl = UIRefreshControl()
    var arrData = NSMutableArray()
    var lastOffset_y :CGFloat!
    var offset_up:CGFloat!
    var offset_down:CGFloat!
    var net_down:CGFloat!
    var net_up:CGFloat!
    let postButton = UIButton()
    var object_parent:home!
    var isFetched = false
    var counter_variable = 0
    var current_paage = 0
    let floaty = Floaty()
    var selected_postitem = ""
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnFindFriends: UIButton!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var footerLoader: UIActivityIndicatorView!
    @IBOutlet weak var communityTable: UITableView!
    var selectedIndex = -1

    var dummyLike = [
        "avatar" : "",
        "name" : appDel.loginUserInfo.first_name,
        "user_id" : appDel.loginUserInfo.user_id,
        "username" : appDel.loginUserInfo.username
    ]

    @IBOutlet weak var mainBannerView: UIView!
    override func viewDidLoad()
    {
        lastOffset_y = 0
        offset_up = 0
        offset_down = 0
        net_up = 0
        net_down = 0
        
        super.viewDidLoad()
       
        isFetched = true
        
        if(comman.user_info == nil)
        {
            
            comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        
        floaty.addItem(" Lend ", icon: UIImage.init(named: "lendandborrow prof pic 1x")) { (item) in
            
            self.floatingActions(actiontype: "lend_borrow")
            
        }
        floaty.addItem(" Show Off ", icon: UIImage(named: "show off 1x")!, handler: { item in
           
            self.floatingActions(actiontype: "showoff")
        })
        floaty.addItem(" Borrow ", icon: UIImage.init(named: "shout profile pic 1x")) { (item) in
            
            //self.floatingActions(actiontype: "shout")
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            let object_postitem = strbrd.instantiateViewController(withIdentifier: "OptionTitlePost") as! OptionTitlePost
            object_postitem.modalPresentationStyle = .custom
            object_postitem.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            object_postitem.community = self
            self.present(object_postitem, animated: true, completion: nil)
            
        }
        
        bannerView.layer.cornerRadius = 20
        bannerView.layer.masksToBounds = true
        
        btnFindFriends.layer.cornerRadius = 20
        btnFindFriends.layer.masksToBounds = true
        
        floaty.friendlyTap       = true
        floaty.openAnimationType = .pop
        //floaty.buttonColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1)
        floaty.buttonColor       = UIColor.clear
        floaty.itemTitleColor    = UIColor.black
        floaty.itemImageColor    = .clear
        floaty.paddingY          = comman.safeArea().bottom + 49 + 10
        floaty.buttonImage       = UIImage.init(named: "logo")
        
        print(comman.safeArea().bottom + (appDel.window?.rootViewController?.tabBarController?.tabBar.frame.height ?? 0))
        
        //floaty.frame = CGRect(x: 10,y:200, width:60, height:60)
       self.view.addSubview(floaty)
       UNUserNotificationCenter.current().delegate = self
        
        
        if #available(iOS 10.0, *)
        {
            communityTable.refreshControl = refreshControl
        }
        else {
            communityTable.addSubview(refreshControl)
        }
        let str = NSAttributedString.init(string: "pull to refresh")
        refreshControl.attributedTitle = str
        refreshControl.tintColor = AppColor.themeColor
        refreshControl.addTarget(self, action: #selector(refreshedData), for: .valueChanged)

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.counter_variable = 0
            self.arrData.removeAllObjects()
            //communityTable.reloadData()
            comman.showLoader(toView: self)
            self.getUpdatedData()
        }
        
        communityTable.rowHeight = UITableViewAutomaticDimension
        footerLoader.hidesWhenStopped = true
        communityTable.estimatedRowHeight =  509
        self.mainBannerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
      
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         self.tabBarController?.tabBar.isHidden = false
    }

    func getUpdatedDataForCommunity(){
        counter_variable = 0
        self.arrData.removeAllObjects()
        communityTable.reloadData()
        comman.showLoader(toView: self)
        self.getUpdatedData()
    }


    override func viewDidAppear(_ animated: Bool)
    {
            counter_variable = 0
            self.arrData.removeAllObjects()
            communityTable.reloadData()
            comman.showLoader(toView: self)
            self.getUpdatedData()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    @objc func refreshedData()
    {
        DispatchQueue.main.async {
            self.counter_variable = 0
            self.arrData.removeAllObjects()
            self.communityTable.reloadData()
            self.getUpdatedData()
        }
        
    }


    func getUpdatedData()
    {
        
        if(appDel.loginUserInfo.username == nil)
        {
            comman.hideLoader(toView: self)
            return
        }
        
        isFetched = false
        web_services.badlee_post_with_authentication(page_url: "postbyfollow.php?offset=\(counter_variable)&limit=10" , username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            
            DispatchQueue.main.async {
                
                //  self.arrData.addObjects(from: post_data as! [Any])
                let post_data = data as? NSArray ?? []
                // self.arrData = NSMutableArray(array:)
                
                for item in post_data
                {
                    let post_id = "\((item as! NSDictionary).object(forKey: "id") as? Int ?? 0)"
                    let isFound = comman.isItemAvailable(arr: self.arrData, postID: post_id)
                    if(!isFound)
                    {
                        
                        // self.communityTable.beginUpdates()
                        self.arrData.add(item)
                        let sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                        let sortDescriptors = [sectionSortDescriptor]
                        self.arrData.sort(using: sortDescriptors)
                        self.isFetched = true
                        
                    }
                    
                }
                
                if(self.arrData.count <= 0)
                {
                    self.mainBannerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 350)
                }
                else
                {
                    self.mainBannerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
                }
                
                DispatchQueue.main.async {
                    self.communityTable.reloadData()
                    
                    comman.hideLoader(toView: self)
                    self.refreshControl.endRefreshing()
                    self.footerLoader.stopAnimating()
                }
               
            }
            
        }) { (data) in
            
            if(self.arrData.count <= 0)
            {
                self.bannerHeight.constant = 350
            }
            else
            {
                self.bannerHeight.constant = 0
            }
            comman.hideLoader(toView: self)
            self.refreshControl.endRefreshing()
            self.footerLoader.stopAnimating()
            
        }
    }

    func getupdatedData()
    {
        isFetched = false
        web_services.badlee_post_with_authentication(page_url: "postbyfollow.php?offset=\(counter_variable)&limit=15" , username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            let post_data = data as? NSArray ?? []
            // self.arrData = NSMutableArray(array:)
            
            for item in post_data
            {
                let post_id = "\((item as! NSDictionary).object(forKey: "id") as? Int ?? 0)"
                let isFound = comman.isItemAvailable(arr: self.arrData, postID: post_id)
                if(!isFound)
                {
                    
                    self.communityTable.beginUpdates()
                    
                    self.arrData.add(item)
                    let sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                    let sortDescriptors = [sectionSortDescriptor]
                    self.arrData.sort(using: sortDescriptors)
                    
                    self.communityTable.insertRows(at: [NSIndexPath.init(row: self.arrData.index(of: item), section: 0) as IndexPath], with: .bottom)
                    self.communityTable.endUpdates()
                    self.isFetched = true
                    
                }
                
            }
            
            
            self.footerLoader.stopAnimating()
        }) { (data) in
            
            
            self.footerLoader.stopAnimating()
            
        }
    }


    //MARK:  - tableview delegate & datasource -

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell", for: indexPath) as! itemcell
        
        let avatar = cell.viewWithTag(1) as! UIImageView
        let username = cell.viewWithTag(2) as! UILabel
        let title = cell.viewWithTag(210) as! UILabel
        let location = cell.viewWithTag(4) as! UILabel
        let description = cell.viewWithTag(5) as! UILabel
        // let total_comments = cell.viewWithTag(6) as! UILabel
        let img_purpose = cell.viewWithTag(7) as! UIImageView
        let btnLiked = cell.viewWithTag(8) as! UIButton
        let btnWished = cell.viewWithTag(9) as! UIButton
        let btnComments = cell.viewWithTag(10) as! UIButton
        let btnView = cell.viewWithTag(500) as! UIButton
        let view_container = cell.viewWithTag(100)
        
        view_container?.layer.cornerRadius = 10
        view_container?.layer.masksToBounds = true
        
        let btn_reaction = cell.viewWithTag(20) as! UIButton
        let btn_comments = cell.viewWithTag(21) as! UIButton
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 1
        
        
        let btnUserName = cell.viewWithTag(200) as! UIButton
        btnUserName.addTarget(self, action: #selector(tapped_username(sender:)), for: .touchUpInside)
        
        let btnoption = cell.viewWithTag(12) as! UIButton
        
        btnLiked.addTarget(self, action: #selector(btnLike(sender:)), for: .touchUpInside)
        btnWished.addTarget(self, action: #selector(btnWish(sender:)), for: .touchUpInside)
        btnoption.addTarget(self, action: #selector(setRepor(sender:)), for: .touchUpInside)
        btnComments.addTarget(self, action: #selector(commentsAction(sender:)), for: .touchUpInside)
        btn_comments.addTarget(self, action: #selector(commentsAction(sender:)), for: .touchUpInside)
        btn_reaction.addTarget(self, action: #selector(reactionAction(sender:)), for: .touchUpInside)
        btnView.addTarget(self, action: #selector(gotoSinglePage(sender:)), for: .touchUpInside)
        
        
        let reaction_name = (arrData[indexPath.row] as! NSDictionary).object(forKey: "purpose") as? String ?? "1"
        img_purpose.image = comman.getReaction(reactionName: reaction_name)
        
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.gray.cgColor
        avatar.layer.borderWidth = 0.7
        
        
        let str_date = (arrData[indexPath.row] as! NSDictionary).object(forKey: "timestamp") as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let local_date = Date()
        let server_date = dateFormatter.date(from: str_date!)!
        
        let timestamp = comman.daysBetweenDates(startDate: server_date as NSDate, endDate: local_date as NSDate, inTimeZone: NSTimeZone(name: "UTC")! as TimeZone)
        
        let str_username = (((arrData[indexPath.row] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "username") as? String ?? "")!
        //let userID = (((arrData[indexPath.row] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as? String)!
        
        username.text = str_username
        
        let img_placeholder = UIImage.init(named: "user pic 1x")
        let str_url = StaticURLs.base_url + (((arrData[indexPath.row] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "avatar") as? String ?? "")
        var item_str_url = (arrData[indexPath.row] as! NSDictionary).object(forKey: "media") as! String
        item_str_url = StaticURLs.base_url + item_str_url
        
        let city = comman.getCityName(name: ((arrData[indexPath.row] as! NSDictionary).object(forKey: "location") as? String)!) + " • " + timestamp
        
        let range = (city as NSString).range(of: timestamp)
        
        let attributedString = NSMutableAttributedString(string:city)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: range)
        
        location.attributedText = attributedString
        
        let commentStr = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "description") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        description.text = commentStr
        if(description.isTruncated)
        {
            btnView.isHidden = false
        }
        else
        {
            btnView.isHidden = true
        }
        
        if(indexPath.row == selectedIndex)
        {
            // btnView.isHidden = true
            description.numberOfLines = 0
            cell.btnMoreHeight.constant = 10
            
        }else{
            description.numberOfLines = 2
            cell.btnMoreHeight.constant = 20
            
            // btnView.isHidden = false
        }
        
        
        let comment_count = (arrData[indexPath.row] as! NSDictionary).object(forKey: "comments_count") as? Int ?? 0
        var comments = "0"
        if(comment_count > 1)
        {
            comments =  "\(comment_count)" + " comments"
        }
        else
        {
            comments =  "\(comment_count)" + " comment"
        }
        
        var count_likes = NSArray()
        
        
            count_likes = (arrData[indexPath.row] as! NSDictionary).object(forKey: "likes") as? NSArray ?? []
        
        
        let isLiked = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "like") as? NSString ?? "no"
        
        // print("\(indexPath.row)" + "\(isLiked)")
        
        if(isLiked == "yes")
        {
            btnLiked.setImage(UIImage.init(named: "like 1x"), for: .normal)
            btnLiked.isSelected = true
            btnLiked.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
        }
        else
        {
            btnLiked.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
            btnLiked.isSelected = false
            btnLiked.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        var count_wishes = NSArray()
        
    //        if((arrData[indexPath.row] as! NSDictionary).object(forKey: "wish") is NSArray)
    //        {
        
        
       // }
        
        let isWished = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "wish") as? NSString ?? "no"
        
        let isHave = ((arrData[indexPath.row] as! NSDictionary).object(forKey: "reaction_status") as? NSDictionary)?.object(forKey: "have") as? NSString ?? "no"
        
        if(reaction_name != "3")
        {
             count_wishes = (arrData[indexPath.row] as! NSDictionary).object(forKey: "wish") as? NSArray ?? []
            if( isWished == "no" )
            {
                
                btnWished.setImage(UIImage.init(named: "unwished 1x"), for: .normal)
                btnWished.setTitle("Wish", for: .normal)
                btnWished.setTitleColor(UIColor.darkGray, for: .normal)
                btnWished.isSelected = false
                
            }
            else
            {
                btnWished.setImage(UIImage.init(named: "wish 1x"), for: .normal)
                btnWished.setTitle("Wish", for: .normal)
                btnWished.setTitleColor(UIColor.red, for: .normal)
                btnWished.isSelected = true
            }
            
        }
        else if(reaction_name == "3")
        {
             count_wishes = (arrData[indexPath.row] as! NSDictionary).object(forKey: "have") as? NSArray ?? []
            if( isHave == "no")
            {
                btnWished.setImage(UIImage.init(named: "ihavenot"), for: .normal)
                btnWished.setTitle("Have", for: .normal)
                btnWished.setTitleColor(UIColor.darkGray, for: .normal)
                btnWished.isSelected = false
            }
            else
            {
                btnWished.setImage(UIImage.init(named: "ihave"), for: .normal)
                btnWished.setTitle("Have", for: .normal)
                btnWished.setTitleColor(UIColor.init(red: 131.0/255.0, green: 205.0/255.0, blue: 68.0/255.0, alpha: 1), for: .normal)
                btnWished.isSelected = true
            }
            
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
        
        btn_reaction.setTitle(reactions, for: .normal)
        btn_comments.setTitle(comments, for: .normal)
        
        let avatar_url = URL.init(string: str_url)
        let item_url = URL.init(string: item_str_url)
        
        let gradientLayer = CAGradientLayer(point: .center)
        
        cell.img_item.layer.addSublayer(gradientLayer)
        
        let post_type = (arrData[indexPath.row] as! NSDictionary).object(forKey: "shout_type") as? String ?? ""
        if(post_type == "media" && item_url != nil)
        {
            cell.img_item.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            cell.img_item.image = nil
            cell.img_item.setImageWith(item_url!)
            let ori_type = (arrData[indexPath.row] as! NSDictionary).object(forKey: "orientation") as? String ?? ""
            var height  = 0.0
            
            if(ori_type == "portrait")
            {
                height = Double(UIScreen.main.bounds.width*1.14)
            }
            else if(ori_type == "landscape")
            {
                height = Double(UIScreen.main.bounds.width*0.75)
            }
            cell.imgHeightCons.constant = CGFloat(height)
            title.isHidden = true
            
        }else{
            title.isHidden = false
            let titleDescription = (arrData[indexPath.row] as! NSDictionary).object(forKey: "title") as? String ?? ""
            let titleHeight = titleDescription.height(withConstrainedWidth: title.frame.width, font:UIFont.init(name: "Muli-Regular", size: 14.0)!) + 60
            
            cell.imgHeightCons.constant = CGFloat(titleHeight)
            gradientLayer.frame = cell.img_item.bounds
            title.text = titleDescription
        }
        
        if(avatar_url != nil)
        {
            avatar.setImageWith(avatar_url!, placeholderImage: img_placeholder)
        }
        
        return cell
        
       
    }


    @objc func gotoSinglePage(sender:UIButton){

        DispatchQueue.main.async {
            let cell = sender.superview?.superview?.superview as! itemcell
            guard let index = self.communityTable.indexPath(for: cell) else{
                return
            }
            
            self.selectedIndex  = index.row
            self.communityTable.reloadRows(at: [index], with: .none)
        }
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        let description = cell.viewWithTag(5) as! UILabel
        let btnView = cell.viewWithTag(500) as! UIButton
        
        if(indexPath.row == selectedIndex)
        {
            // btnView.isHidden = true
            description.numberOfLines = 0
            btnView.isHidden = true
            
            
        }else{
            if(description.isTruncated){
                btnView.isHidden = false
            }else{
                btnView.isHidden = true
            }
            description.numberOfLines = 2
            // btnView.isHidden = false
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if((self.lastContentOffset > scrollView.contentOffset.y) || scrollView.contentOffset.y <= 0) &&
            self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height) {
            
            UIView.animate(withDuration: 0.3) {
                self.floaty.isHidden = false
            }
            
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y
            && scrollView.contentOffset.y > 0)
        {
            UIView.animate(withDuration: 0.3) {
               self.floaty.isHidden = true
            }
            
        }
        
        let count_row = IndexPath.init(row: arrData.count-1, section: 0)
        let  height = communityTable.frame.size.height
        let contentYoffset = communityTable.contentOffset.y
        let distanceFromBottom = communityTable.contentSize.height - contentYoffset
        if distanceFromBottom < height && self.arrData.count > 0 {
            
            print("you have reached at end poind")
            
            counter_variable = counter_variable + 10
            print("limit: \(counter_variable)")
           // comman.showLoader(toView: self)
            self.footerLoader.startAnimating()
            
            DispatchQueue.global().async {
                self.getupdatedData()
                self.current_paage = count_row.row
            }
           
           
        }
        
        
        self.lastContentOffset = scrollView.contentOffset.y
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        UIView.animate(withDuration: 0.3)
        {
            self.floaty.isHidden = false
        }
        
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        UIView.animate(withDuration: 0.3)
        {
            self.floaty.isHidden = false
        }
        
    }



    //MARK: - like or unlike -

    @objc func btnLike(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let index = communityTable.indexPath(for: cell)
        
        let post_id = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "id") as! Int
        
        let btn_reaction = cell.viewWithTag(20) as! UIButton
        let totalReactionStr = btn_reaction.titleLabel?.text
        var reactionCount = (totalReactionStr?.components(separatedBy: " ").first! as! NSString).intValue
        var reactions = ""
       
        
        let img = UIImage.init(named: "like 1x")
        
        let url = "like.php?postid=" + "\(post_id)"
        
        if(img == sender.imageView?.image)
        {
            //liked
            sender.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
            sender.setTitleColor(UIColor.darkGray, for: .normal)
            
            //  (( self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary).setValue("no", forKey: "like")
            reactionCount = reactionCount > 1 ? reactionCount-1:reactionCount
            if(reactionCount > 1)
            {
                reactions =  "\(reactionCount)" + " reactions"
            }
            else
            {
                reactions =  "\(reactionCount)" + " reaction"
            }
            
            btn_reaction.setTitle(reactions, for: .normal)
            
            let dict = self.arrData[(index?.row)!] as! NSDictionary
            
            let dict_like = (self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary
            let arrLikes = dict.object(forKey: "likes") as? Array ?? []
            let arrUpdated = NSMutableArray(array: arrLikes)
            
            for item in arrLikes{
                let lk = item as! NSDictionary
                if((lk.object(forKey: "user_id") as! String) == appDel.loginUserInfo.user_id){
                    arrUpdated.remove(item)
                    break
                }
            }
            
            let updatedLikes = NSMutableDictionary(dictionary:dict)
            updatedLikes.setValue(arrUpdated, forKey: "likes")
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            dict_mutLike.setValue("no", forKey: "like")
            
            
            let dict_mut = NSMutableDictionary(dictionary:dict)
            
            dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
            
            self.arrData[(index?.row)!] = dict_mut
            self.arrData[(index?.row)!] = updatedLikes
            
            
            web_services.badlee_delete_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                
                let isUnliked = data?.object(forKey: "status") as! Bool
                if(isUnliked == false)
                {
                    (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "no"
                }
                
                
            }, failure: { (data) in
                sender.setImage(UIImage.init(named: "like 1x"), for: .normal)
                sender.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
                
                dict_mutLike.setValue("yes", forKey: "like")
                
                let dict_mut = NSMutableDictionary(dictionary:dict)
                
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.arrData[(index?.row)!] = dict_mut
            })
        }
        else
        {
            // not liked
            
            sender.setImage(UIImage.init(named: "like 1x"), for: .normal)
            sender.setTitleColor(UIColor.init(red: 97.0/255.0, green: 19.0/255.0, blue: 101.0/255.0, alpha: 1), for: .normal)
            //  (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "yes"
            
            
            let dict = self.arrData[(index?.row)!] as! NSDictionary
            
            let dict_like = (self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            dict_mutLike.setValue("yes", forKey: "like")
            
            let dict_mut = NSMutableDictionary(dictionary:dict)
            
            dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
            
            self.arrData[(index?.row)!] = dict_mut
            
            let arrLikes = dict.object(forKey: "likes") as? Array ?? []
            let arrUpdated = NSMutableArray(array: arrLikes)
            
            arrUpdated.add(dummyLike)
           
            let updatedLikes = NSMutableDictionary(dictionary:dict)
            updatedLikes.setValue(arrUpdated, forKey: "likes")
            
            self.arrData[(index?.row)!] = updatedLikes
            
            reactionCount = reactionCount + 1
            if(reactionCount > 1)
            {
                reactions =  "\(reactionCount)" + " reactions"
            }
            else
            {
                reactions =  "\(reactionCount)" + " reaction"
            }
            
            btn_reaction.setTitle(reactions, for: .normal)
            
            
            web_services.badlee_post_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                
                if(data is Dictionary<String, Any>)
                {
                    let userID = data?.object(forKey: "userid")
                    if(userID != nil)
                    {
                        // (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "yes"
                    }
                }
                
                
                
            })
            { (data) in
                sender.setImage(UIImage.init(named: "unliked 1x"), for: .normal)
                sender.setTitleColor(UIColor.darkGray, for: .normal)
                //  (( self.arrData[(index?.row)!] as! NSMutableDictionary).object(forKey: "reaction_status") as! NSMutableDictionary)["like"] = "no"
                dict_mutLike.setValue("no", forKey: "like")
                
                let dict_mut = NSMutableDictionary(dictionary:dict)
                
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.arrData[(index?.row)!] = dict_mut
            }
        }
    }

    @objc func btnWish(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let index = communityTable.indexPath(for: cell)
        
        let btn_reaction = cell.viewWithTag(20) as! UIButton
        let totalReactionStr = btn_reaction.titleLabel?.text
        var reactionCount = (totalReactionStr?.components(separatedBy: " ").first! as! NSString).intValue
        var reactions = ""
        
        
        let post_id = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "id") as! Int
        
        let img_wished = UIImage.init(named: "wish 1x")
        //let img_unwished = UIImage.init(named: "unwished 1x")
        
        let reaction_name = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "purpose") as? String
        
        
        if(reaction_name != "3")
        {
            //wished / unwished
            let url = "wish.php?postid=" + "\(post_id)"
            
            let dict = self.arrData[(index?.row)!] as! NSDictionary
            
            let dict_like = (self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            
            if(img_wished == sender.imageView?.image)
            {
                
                let arrLikes = dict.object(forKey: "wish") as? Array ?? []
                let arrUpdated = NSMutableArray(array: arrLikes)
                
                for item in arrLikes{
                    let lk = item as! NSDictionary
                    if((lk.object(forKey: "user_id") as! String) == appDel.loginUserInfo.user_id){
                        arrUpdated.remove(item)
                        break
                    }
                }
                
                reactionCount = reactionCount > 1 ? reactionCount-1:reactionCount
                if(reactionCount > 1)
                {
                    reactions =  "\(reactionCount)" + " reactions"
                }
                else
                {
                    reactions =  "\(reactionCount)" + " reaction"
                }
                
                btn_reaction.setTitle(reactions, for: .normal)
                
                
                let updatedLikes = NSMutableDictionary(dictionary:dict)
                updatedLikes.setValue(arrUpdated, forKey: "wish")
               
                dict_mutLike.setValue("no", forKey: "wish")
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                
                self.arrData[(index?.row)!] = dict_mut
                self.arrData[(index?.row)!] = updatedLikes
                
                sender.setImage(UIImage.init(named: "unwished 1x"), for: .normal)
                sender.setTitleColor(UIColor.darkGray, for: .normal)
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
                
                self.arrData[(index?.row)!] = dict_mut
                sender.setImage(UIImage.init(named: "wish 1x"), for: .normal)
                sender.setTitleColor(UIColor.red, for: .normal)
                sender.isSelected = true
                
                reactionCount = reactionCount + 1
                if(reactionCount > 1)
                {
                    reactions =  "\(reactionCount)" + " reactions"
                }
                else
                {
                    reactions =  "\(reactionCount)" + " reaction"
                }
                
                btn_reaction.setTitle(reactions, for: .normal)
            
                let arrLikes = dict.object(forKey: "wish") as? Array ?? []
                let arrUpdated = NSMutableArray(array: arrLikes)
                
                arrUpdated.add(dummyLike)
                
                let updatedLikes = NSMutableDictionary(dictionary:dict)
                updatedLikes.setValue(arrUpdated, forKey: "wish")
                
                self.arrData[(index?.row)!] = updatedLikes
                
                
                web_services.badlee_post_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                    
                    
                }) { (data) in
                    
                    
                }
            }
            
        }
        else
        {
            // have / not have
            
            let  url = "have.php?postid=" + "\(post_id)"
            let dict = self.arrData[(index?.row)!] as! NSDictionary
            
            let img_have = UIImage.init(named: "ihave")
            let img_havenot = UIImage.init(named: "ihavenot")
            
            let dict_like = (self.arrData[(index?.row)!] as! NSDictionary).object(forKey: "reaction_status") as! NSDictionary
            
            let dict_mutLike = NSMutableDictionary(dictionary:dict_like)
            
            if(img_havenot == sender.imageView?.image )
            {
                dict_mutLike.setValue("yes", forKey: "have")
                let dict_mut = NSMutableDictionary(dictionary:dict)
                dict_mut.setValue(dict_mutLike, forKey: "reaction_status")
                sender.setImage(img_have, for: .normal)
                sender.setTitleColor(UIColor.init(red: 131.0/255.0, green: 205.0/255.0, blue: 68.0/255.0, alpha: 1), for: .normal)
                self.arrData[(index?.row)!] = dict_mut
                sender.isSelected = true
                
                reactionCount = reactionCount + 1
                if(reactionCount > 1)
                {
                    reactions =  "\(reactionCount)" + " reactions"
                }
                else
                {
                    reactions =  "\(reactionCount)" + " reaction"
                }
                
                btn_reaction.setTitle(reactions, for: .normal)
                
                let arrLikes = dict.object(forKey: "have") as? Array ?? []
                let arrUpdated = NSMutableArray(array: arrLikes)
                
                arrUpdated.add(dummyLike)
                
                let updatedLikes = NSMutableDictionary(dictionary:dict)
                updatedLikes.setValue(arrUpdated, forKey: "have")
                
                self.arrData[(index?.row)!] = updatedLikes
                
               
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
                sender.setTitleColor(UIColor.darkGray, for: .normal)
                sender.isSelected = false
                self.arrData[(index?.row)!] = dict_mut
                
                let arrLikes = dict.object(forKey: "have") as? Array ?? []
                let arrUpdated = NSMutableArray(array: arrLikes)
                
                for item in arrLikes{
                    let lk = item as! NSDictionary
                    if((lk.object(forKey: "user_id") as! String) == appDel.loginUserInfo.user_id){
                        arrUpdated.remove(item)
                        
                    }
                }
                
                reactionCount = reactionCount > 1 ? reactionCount-1:reactionCount
                if(reactionCount > 1)
                {
                    reactions =  "\(reactionCount)" + " reactions"
                }
                else
                {
                    reactions =  "\(reactionCount)" + " reaction"
                }
                
                btn_reaction.setTitle(reactions, for: .normal)
                
                let updatedLikes = NSMutableDictionary(dictionary:dict)
                updatedLikes.setValue(arrUpdated, forKey: "have")
                self.arrData[(index?.row)!] = updatedLikes
                
               
                
                web_services.badlee_delete_with_authentication(page_url: url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    
                }, failure: { (data) in
                    
                    
                })
            }
            
        }
    }


    @objc func setRepor(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
    
        let index = communityTable.indexPath(for: cell)
        let username = (((arrData[(index?.row)!] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "username") as? String)!
        let userid = (((arrData[(index?.row)!] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as? String)!
        
        let itemid = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "id") as! Int
        
         let imgURL = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "media") as! String
        
        let itemtype = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "purpose") as? String
        
        let item_description = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "description") as? String
        
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
                 self.askToDelete(post_id: "\(itemid)", index:  (index?.row)!)
                //self.deletePost(post_id: "\(itemid)", index: (index?.row)!)
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

    func reporting(message:String,itemid:String,itemtype:String)
    {
        let dict = ["itemid":itemid, "itemtype":"post","message":message,"application_id":app_id,"application_secret":app_secret_key]
        
        comman.showLoader(toView: self)
        
        web_services.badlee_post_with_param(param:dict as NSDictionary,page_url: "report.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            self.showToast(message: "Post has been reported")
            comman.hideLoader(toView: self)
            
        }) { (dara) in
            
            self.showToast(message: "You have already reported this post")
            comman.hideLoader(toView: self)
        }
    }

    @objc func tapped_username(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let index = communityTable.indexPath(for: cell)
        
        let userID = ((arrData[(index?.row)!] as! NSDictionary).object(forKey: "user_info") as! NSDictionary).object(forKey: "user_id") as! String
        if(userID != appDel.loginUserInfo.user_id!)
        {
            let isBlocked = comman.checkPermission(reciever_userID: userID)
            let userObject = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! userProfile
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

    @objc func commentsAction(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let index = communityTable.indexPath(for: cell)
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object_comments = strbrd.instantiateViewController(withIdentifier: "commentsVC") as! commentsVC
        object_comments.arrComments = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "comments") as? Array<Any> ?? []
        object_comments.post_id = (arrData[(index?.row)!] as! NSDictionary).object(forKey: "id") as? Int
        self.present(object_comments, animated: true, completion: nil)
       // self.navigationController?.pushViewController(object_comments, animated: true)
        
    }

    @objc func reactionAction(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let index = communityTable.indexPath(for: cell)
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object_comments = strbrd.instantiateViewController(withIdentifier: "reactionsVC") as! reactionsVC
        object_comments.reactions = (arrData[(index?.row)!] as! NSDictionary)
        self.present(object_comments, animated: true, completion: nil)
        //self.navigationController?.pushViewController(object_comments, animated: true)
        
    }


    func floatingActions(actiontype:String)
    {
        
       // let pickerController = UIImagePickerController()
        
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
        
        let pickerController = UIImagePickerController()
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
    
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            let galleryObject = strbrd.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
            galleryObject.selected_postitem = self.selected_postitem
            galleryObject.homeObject = self
            self.navigationController?.pushViewController(galleryObject, animated: true)
            
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
        
        let   image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
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


    @IBAction func btnFindFriends(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "suggestedUser") as! suggestedUser
        self.present(object, animated: true, completion: nil)
        
    }

    func deletePost(post_id:String,index:Int)
    {
        comman.showLoader(toView: self)
        web_services.badlee_delete_with_authentication(page_url: "posts.php?postid=\(post_id)", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
            self.arrData.removeObject(at: index)
            self.showToast(message: "Your post has been deleted")
            self.communityTable.reloadData()
            self.counter_variable = 0
            comman.hideLoader(toView: self)
            self.getUpdatedData()
            
            
        }) { (err) in
            comman.hideLoader(toView: self)
            self.getUpdatedData()
        }
    }

    func askToDelete(post_id:String,index:Int)
    {
        let optionMenu = UIAlertController(title: "Delete", message: "Are you sure want to delete this post?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "YES", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
         
           self.deletePost(post_id: post_id, index: index)
            
        })
        
        let no = UIAlertAction(title: "NO", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(no)
        optionMenu.addAction(yes)
        self.present(optionMenu, animated: true, completion: nil)
        
    }

    }


    extension UIViewController
    {

    func showToast(message : String)
    {
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: 50, y: UIScreen.main.bounds.height-100, width:UIScreen.main.bounds.width - 100, height: 40))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Muli-Regular", size: 12.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.window?.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    }

    extension UILabel {

    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        print(bounds.size.height)
        return (labelTextSize.height-20) > bounds.size.height
    }

    }
