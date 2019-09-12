

import UIKit
import Floaty

class search_itemCell: UITableViewCell
{
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var actionbutton: UIButton!
    @IBOutlet weak var username: UILabel!
}
class search_itemVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,shareDataDelagate,TrendingProductsCustomDelegate

{
   
    @IBOutlet weak var nav_view: UIView!
    private let refreshControl = UIRefreshControl()
    private let refreshControl1 = UIRefreshControl()
    @IBOutlet weak var footerLoader: UIActivityIndicatorView!
    var counter_variable = 0
    var mainData:NSArray!
    var thingies = NSMutableArray()
    var folks = NSMutableArray()
    @IBOutlet weak var btnLoc: UIButton!
    @IBOutlet weak var btnCat: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var location_cateView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnFolks: UIButton!
    @IBOutlet weak var btnThingies: UIButton!
    @IBOutlet weak var view_cat: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnCategory: UIButton!
    private var lastContentOffset: CGFloat = 0
    var category_id = ""
    var purpose_id = ""
    var location_id = ""
    var keywords = ""
    var isFetched = false
    
    @IBOutlet weak var submenuCons: NSLayoutConstraint!
    let floaty = Floaty()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view_cat.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view_cat.layer.shadowOpacity = 0.6
        view_cat.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view_cat.layer.shadowRadius = 0.5
        
        location_cateView.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        location_cateView.layer.shadowOpacity = 1
        location_cateView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        location_cateView.layer.shadowRadius = 1.0
        tableview.tableFooterView = UIView.init(frame: .zero)
        
        btnCat.layer.cornerRadius = btnCat.frame.height/2
        btnCat.layer.masksToBounds = true
        
        btnLoc.layer.cornerRadius = btnLoc.frame.height/2
        btnLoc.layer.masksToBounds = true
        
        btnLoc.isHidden = true
        btnCat.isHidden = true
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.black
        textFieldInsideUISearchBar?.font = UIFont.init(name: "Muli-Regular", size: 15)
        
        
        if #available(iOS 10.0, *)
        {
            tableview.refreshControl = refreshControl1
            collectionview.refreshControl = refreshControl
        }
        else
        {
            tableview.addSubview(refreshControl1)
            collectionview.addSubview(refreshControl)
        }
        
        let str = NSAttributedString.init(string: "pull to refresh")
        refreshControl.attributedTitle = str
        refreshControl.tintColor = AppColor.themeColor
        refreshControl.addTarget(self, action: #selector(refreshedData), for: .valueChanged)

        refreshControl1.attributedTitle = str
        refreshControl1.tintColor = AppColor.themeColor
        refreshControl1.addTarget(self, action: #selector(refreshedData), for: .valueChanged)

       
        
        floaty.addItem(" Lend ", icon: UIImage.init(named: "lendandborrow prof pic 1x")) { (item) in
            
            self.purpose_id = "1"
            
            if(Int(self.keywords.count) >= 0)
            {
                comman.showLoader(toView: self)
                self.folks.removeAllObjects()
                self.thingies.removeAllObjects()
                self.search_result(keyword: self.keywords, limit: 0)
            }
            else
            {
                self.filterposts(post: "1")
            }
            
            let reaction = comman.getReaction(reactionName: "1")
            self.floaty.buttonImage = reaction
        }
        floaty.addItem(" Show Off ", icon: UIImage(named: "show off 1x")!, handler: { item in
            
            self.purpose_id = "2"
            
            if(Int(self.keywords.count) >= 0)
            {
                comman.showLoader(toView: self)
                
                self.folks.removeAllObjects()
                self.thingies.removeAllObjects()
                
                self.search_result(keyword: self.keywords, limit: 0)
            }
            else
            {
                self.filterposts(post: "2")
            }
            let reaction = comman.getReaction(reactionName: "2")
            self.floaty.buttonImage = reaction
            
        })
        floaty.addItem(" Borrow ", icon: UIImage.init(named: "shout profile pic 1x")) { (item) in
            
            self.purpose_id = "3"
            
            if(Int(self.keywords.count) >= 0)
            {
                comman.showLoader(toView: self)
                self.folks.removeAllObjects()
                self.thingies.removeAllObjects()
                self.search_result(keyword: self.keywords, limit: 0)
            }
            else
            {
                self.filterposts(post: "3")
            }
            
            let reaction = comman.getReaction(reactionName: "3")
            self.floaty.buttonImage = reaction
            
        }
        
        
        floaty.addItem(" All", icon: UIImage(named: "allpurpose")!, handler: { item in
            
            self.floaty.buttonImage = UIImage.init(named: "filter")
            self.purpose_id = ""

            if(Int(self.keywords.count) >= 0)
            {
                comman.showLoader(toView: self)
                self.search_result(keyword: self.keywords, limit: 0)
            }
            
        })
        
        
        floaty.friendlyTap = true
        floaty.openAnimationType = .pop
        floaty.buttonColor = AppColor.themeColor
        floaty.rotationDegrees = 0
        //floaty.buttonColor = UIColor.clear
        floaty.itemTitleColor = UIColor.black
        floaty.itemImageColor  = .clear
        floaty.buttonImage = UIImage.init(named: "filter")
        self.view.addSubview(floaty)
        
        tableview.isHidden = true
        collectionview.isHidden = false
        
        category_id = ""
        comman.showLoader(toView: self)
        self.search_result(keyword: keywords, limit: 0)
        
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        
    }
    
    @objc func refreshedData()
    {
        if(isFetched)
        {
            self.counter_variable = 0
            self.folks.removeAllObjects()
            self.thingies.removeAllObjects()
            self.collectionview.reloadData()
            self.tableview.reloadData()
            self.search_result(keyword: keywords, limit: self.counter_variable)
            
        }
        
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BTNTHINGS(_ sender: UIButton)
    {
         submenuCons.constant = 44
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
        }
       
        sender.isSelected = true
        btnFolks.isSelected = false
        tableview.isHidden = true
        collectionview.isHidden = false
        btnCategory.isHidden = false
        btnLocation.isHidden = false
        floaty.isHidden = false
        
        let kwrd = searchBar.text!
        if(kwrd.count > 0)
        {
            self.search_result(keyword: keywords, limit: 0)
        }
        else
        {
            comman.hideLoader(toView: self)
        }
       // self.collectionview.reloadData()
        
    }
    @IBAction func BTNFOLKS(_ sender: UIButton)
    {
        
        submenuCons.constant = 0
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
        }
        
        sender.isSelected = true
        btnThingies.isSelected = false
        tableview.isHidden = false
        collectionview.isHidden = true
        btnCategory.isHidden = true
        btnLocation.isHidden = true
        floaty.isHidden = true
        
        let kwrd = searchBar.text!
        if(kwrd.count > 0)
        {
            self.search_result(keyword: keywords, limit: 0)
        }
        else
        {
            comman.hideLoader(toView: self)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size =  UIScreen.main.bounds.width/3 - 15/2
        
        return CGSize(width: size, height: size)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return thingies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img_item = cell.viewWithTag(1) as! UIImageView
        let img_purpose = cell.viewWithTag(2) as! UIImageView
        let title = cell.viewWithTag(210) as! UILabel
        
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = true
        
        let item_str_url = StaticURLs.base_url + (((thingies[indexPath.row] as! NSDictionary).object(forKey: "thumb") as? NSDictionary)?.object(forKey: "mini") as? String ?? "")
        let item_url = URL.init(string: item_str_url)
        
        img_item.image = nil
        
        let gradientLayer = CAGradientLayer(point: .center)
        img_item.layer.addSublayer(gradientLayer)
        
        let post_type = (thingies[indexPath.row] as! NSDictionary).object(forKey: "shout_type") as? String ?? ""
        
        if(post_type == "media" && item_url != nil)
        {
            img_item.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            //img_item.setImageWith(item_url!, placeholderImage: UIImage(named: "image_icon"))
            img_item.setImageWith(URLRequest(url: item_url!), placeholderImage: nil, success: { (er, res, img) in
                img_item.image = img
            }) { (re, res, er) in
                
            }
            title.isHidden = true
            img_purpose.isHidden = false
            
        }else{
            
            title.isHidden = false
           // img_purpose.isHidden = true
            let titleDescription = (thingies[indexPath.row] as! NSDictionary).object(forKey: "title") as? String ?? ""
            gradientLayer.frame = img_item.bounds
            title.text = titleDescription
        }
        
        let reaction_name = (thingies[indexPath.row] as! NSDictionary).object(forKey: "purpose") as? String
        img_purpose.image = comman.getReaction(reactionName: reaction_name!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let post_id = (thingies[(indexPath.row)] as! NSDictionary).object(forKey: "id") as! Int
        let object_itemDescription = strbrd.instantiateViewController(withIdentifier: "singlePage") as! singlePage
        object_itemDescription.post_id = post_id
         self.present(object_itemDescription, animated: true, completion: nil)
        //self.navigationController?.pushViewController(object_itemDescription, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return folks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
        let cell: search_itemCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! search_itemCell
    
        let username = ((folks[indexPath.row] as! NSDictionary).object(forKey: "First_name") as? String ?? "") + " " +  ((folks[indexPath.row] as! NSDictionary).object(forKey: "Last_name") as? String ?? "")
    
        let user_profile_url = StaticURLs.base_url + ((folks[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? "")
    
        cell.profile_image.layer.cornerRadius = cell.profile_image.frame.height/2
        cell.profile_image.layer.masksToBounds = true
        cell.actionbutton.layer.borderColor = UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1).cgColor
        cell.actionbutton.layer.borderWidth = 1
        cell.actionbutton.layer.cornerRadius = cell.actionbutton.frame.height/2
        cell.actionbutton.layer.masksToBounds = true
        let user_id = (folks[indexPath.row] as! NSDictionary).object(forKey: "user_id") as? String ?? ""
    
    cell.actionbutton.addTarget(self, action: #selector(btnAddAction(_:)), for: .touchUpInside)
        let isFollowed = comman.isAdded(user_id: user_id)
    
    if(isFollowed == "ADDED" && user_id !=  appDel.loginUserInfo.user_id){
       
            cell.actionbutton.setTitle("ADDED", for: .normal)
            cell.actionbutton.isHidden = false
            cell.actionbutton.backgroundColor = AppColor.themeColor
            cell.actionbutton.setTitleColor(UIColor.white, for: .normal)
            cell.actionbutton.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
        
        }
        else if(isFollowed == "ADD" && user_id !=  appDel.loginUserInfo.user_id)
        {
            cell.actionbutton.setTitle("ADD", for: .normal)
            cell.actionbutton.isHidden = false
            cell.actionbutton.backgroundColor = UIColor.white
            cell.actionbutton.setImage(UIImage.init(named: "community_small"), for: .normal)
            cell.actionbutton.setTitleColor(AppColor.themeColor, for: .normal)
            
        }
       else
        {
          cell.actionbutton.setTitle("", for: .normal)
          cell.actionbutton.isHidden = true
        }
    
    
        let profile_url = URL.init(string: user_profile_url)
        cell.profile_image.image = nil
        
        if(profile_url != nil)
        {
            cell.profile_image.setImageWith(profile_url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        cell.username.text = username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
        let userID = (folks[(indexPath.row)]  as! NSDictionary).object(forKey: "user_id") as! String
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.4) {
            
            self.floaty.isHidden = true
        }
        
        if((self.lastContentOffset > scrollView.contentOffset.y) || scrollView.contentOffset.y <= 0) &&
            self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height)
        {
            
//            UIView.animate(withDuration: 0.3)
//            {
//                self.floaty.isHidden = false
//            }
            
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y
            && scrollView.contentOffset.y > 0)
        {
            UIView.animate(withDuration: 0.3)
            {
                self.floaty.isHidden = true
            }
            
            
        }
        
      
        let  height = collectionview.frame.size.height
        let contentYoffset = collectionview.contentOffset.y
        let distanceFromBottom = collectionview.contentSize.height - contentYoffset
        if distanceFromBottom < height && thingies.count > 0 {
            
            print("you have reached at end poind")
            
            counter_variable = thingies.count
            
           // self.footerLoader.startAnimating()
            if(isFetched)
            {
                self.search_result(keyword: self.keywords, limit: self.counter_variable)
                
            }
            
            
            
        }
        
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(btnFolks.isSelected == false)
        {
            UIView.animate(withDuration: 0.3)
            {
                self.floaty.isHidden = false
            }
        }
       
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(btnFolks.isSelected == false)
        {
            UIView.animate(withDuration: 0.3)
            {
                self.floaty.isHidden = false
            }
        }
    }
    
    func users()
    {
        
        folks.removeAllObjects()
        
        for i in 0..<mainData.count
        {
            let username = ((mainData[i] as! NSDictionary).object(forKey: "user_info") as? NSDictionary)?.object(forKey: "user_id") as? String ?? ""
            
            let resultPredicate = NSPredicate(format: "user_id MATCHES %@", username)
            let isFound = folks.filtered(using: resultPredicate)
            
            let dict = (mainData[i] as! NSDictionary).object(forKey: "user_info") as! NSDictionary
            
            if(isFound.count <= 0)
            {
                folks.add(dict)
                print(username)
            }
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        //self.search_result(keyword: keywords)
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        keywords = searchBar.text ?? ""
        //comman.showLoader(toView: self)
        self.search_result(keyword: keywords, limit: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        keywords = searchText
       // comman.showLoader(toView: self)
        if(searchText.count > 2 || searchText == "" ){
            self.search_result(keyword: keywords, limit: 0)
        }
        
    }
   
   
    
    func search_result(keyword:String,limit:Int)
    {
       var keyowrd = keyword
        
        var purposeID = ""
        var locationID = ""
        var Cat = ""
        
        if(category_id.count > 0)
        {
            Cat = "=" + category_id
        }
        
        if(purpose_id.count > 0)
        {
            
            purposeID = "=" + purpose_id
        }
        
        if(keyword.count > 0)
        {
            keyowrd = "=" + keyowrd
        }
        
        if(location_id.count > 0)
        {
            locationID = "=" + location_id
        }
     
         isFetched = false
        
        web_services.badlee_get(page_url: "search.php?sp\(keyowrd)&spp\(purposeID)&spc\(Cat)&spl\(locationID)&offset=\(limit)&limit=\(limit + 12)", isFuckingKey: true, success: { (data) in
            
            print(data!)
            
            self.mainData = (data as! NSDictionary).object(forKey: "folks") as? NSArray ?? []
            let things = (data as! NSDictionary).object(forKey: "things") as? NSArray ?? []
           // if(things.count > 0){
                self.thingies.removeAllObjects()
          //  }
            if(self.mainData.count > 0){
                self.folks.removeAllObjects()
            }
         
            for item in things
            {
                let post_id = "\((item as! NSDictionary).object(forKey: "id") as? Int ?? 0)"
                let isFound = comman.isItemAvailable(arr: self.thingies, postID: post_id)
                if(!isFound)
                {
                    self.thingies.add(item)
                }
                
            }
            
            for item in self.mainData
            {
                let post_id = "\((item as! NSDictionary).object(forKey: "user_id") as? String ?? "")"
                let isFound = comman.isUserAvailable(arr: self.folks, postID: post_id)
                if(!isFound)
                {
                    self.folks.add(item)
                }
                
            }
           
            self.collectionview.reloadData()
            self.tableview.reloadData()
            comman.hideLoader(toView: self)
            self.refreshControl.endRefreshing()
            self.refreshControl1.endRefreshing()
            self.isFetched = true
            
        }) { (error) in
            comman.hideLoader(toView: self)
            self.refreshControl.endRefreshing()
            self.refreshControl1.endRefreshing()
            self.isFetched = true
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkuserfriends(user_id:String) ->Int
    {
        
        if(comman.user_info != nil)
        {
            let user_info = comman.user_info.object(forKey: "following") as? NSArray ?? []
            
            let predicate = NSPredicate(format: "user_id_following like %@",user_id)
            let filteredArray = user_info.filter { predicate.evaluate(with: $0) };
            
            if(filteredArray.count > 0)
            {
                return 1
            }
            else if(user_id == appDel.loginUserInfo.user_id)
            {
                return 2
            }
            else
            {
                return 0
            }
            //print(filteredArray)
        }
        
        
        return 0
    }
    
    
    @objc func btnAddAction(_ sender: UIButton)
    {
        let cell = sender.superview?.superview as! UITableViewCell
        let index = tableview.indexPath(for: cell)
        
        let userID = (folks[(index?.row)!] as! NSDictionary).object(forKey: "user_id") as! String
       
        let page_url = "follow.php?userid=" + userID
        

        if(sender.titleLabel?.text == "ADDED")
        {
            let alert = UIAlertController(title: "Badlee", message: "Do you want to unfollow the user?", preferredStyle: UIAlertControllerStyle.alert)
            
            let actionOK : UIAlertAction = UIAlertAction(title: "YES", style: .default) { (alt) in
                
                //   comman.showLoader(toView: self)
                sender.setTitle("ADD", for: .normal)
                
                sender.backgroundColor = UIColor.white
                sender.setImage(UIImage.init(named: "community_small"), for: .normal)
                sender.setTitleColor(AppColor.themeColor, for: .normal)
                
                web_services.badlee_delete_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, success: { (data) in
                    
                    sender.setTitle("ADD", for: .normal)
                    
                    sender.backgroundColor = UIColor.white
                    sender.setImage(UIImage.init(named: "community_small"), for: .normal)
                    sender.setTitleColor(AppColor.themeColor, for: .normal)
                    comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                    comman.hideLoader(toView: self)
                    
                    
                }, failure: { (data) in
                    comman.hideLoader(toView: self)
                    comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
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
            //comman.showLoader(toView: self)
            
            sender.backgroundColor = AppColor.themeColor
            sender.setTitle("ADDED", for: .normal)
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
            
            web_services.badlee_post_with_authentication(page_url: page_url, username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                sender.setTitle("ADDED", for: .normal)
                
                sender.backgroundColor = AppColor.themeColor
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.setImage(UIImage.init(named: "communitywhite_small"), for: .normal)
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
                comman.hideLoader(toView: self)
            }, failure: { (data) in
                comman.hideLoader(toView: self)
                comman.getUserInfo(userID: appDel.loginUserInfo.user_id!)
            })
        }
        
    
        
    }
    
    @IBAction func pickLocation(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "citiesVC") as! citiesVC
        object.shareDataDelegate = self
        object.selected_city_id = location_id
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.present(object, animated: true, completion: nil)
    }
    
    @IBAction func pickCategoty(_ sender: Any)
    {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "interested_catogories") as! interested_catogories
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        object.customDelegateForDataReturn = self
        object.isFrom  = "search"
        object.selected_row = NSMutableArray()
        object.selected_row.add(Int(category_id) ?? -1)
        self.present(object, animated: true, completion: nil)
        
    }
    
    func sendDataBackToHomePageViewController(data: String?, data2:String)
    {
        btnCategory.setTitle(data, for: .normal)
        category_id = data2
        btnCat.isHidden = false
        
        if(Int(self.keywords.count) >= 0)
        {
            counter_variable = 0
            thingies.removeAllObjects()
            folks.removeAllObjects()
            comman.showLoader(toView: self)
            self.search_result(keyword: self.keywords, limit: 0)
        }
    }
    
    func sendData(data: String?, city_id: String?)
    {
        
        btnLocation.setTitle(data, for: .normal)
        location_id = city_id!
        btnLoc.isHidden = false
        
        if(Int(self.keywords.count) >= 0)
        {
            counter_variable = 0
            thingies.removeAllObjects()
            folks.removeAllObjects()
            comman.showLoader(toView: self)
            self.search_result(keyword: self.keywords, limit: 0)
            
        }
    }
    
    func filterposts(post:String)
    {
        let predicate = NSPredicate(format: "purpose like %@",post)
        
        let result = mainData.filter { predicate.evaluate(with: $0) };
        
        thingies .removeAllObjects()
        thingies.addObjects(from: result)
        
        self.users()
        self.collectionview.reloadData()
        self.tableview.reloadData()
        
    }
    
    func showAllData()
    {
        thingies.removeAllObjects()
        folks.removeAllObjects()
        if(mainData != nil)
        {
            self.thingies.addObjects(from: mainData as! [Any])
        }
        else
        {
            mainData = NSArray()
        }
       
        self.users()
        tableview.reloadData()
        collectionview.reloadData()
        
        
    }
    
    @IBAction func btnCatRemove(_ sender: Any)
    {
        category_id = ""
        btnCat.isHidden = true
        btnCategory.setTitle("Category", for: .normal)
        comman.showLoader(toView: self)
        self.search_result(keyword: keywords, limit: 0)
    }
    
    @IBAction func btnLocaction(_ sender: Any)
    {
        btnLoc.isHidden = true
        location_id = ""
        btnLocation.setTitle("Location", for: .normal)
        comman.showLoader(toView: self)
        self.search_result(keyword: keywords, limit: 0)
    }
    
}
