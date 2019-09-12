//

//

import UIKit
import Floaty


class home: UIViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate,infor_notification,TrendingProductsCustomDelegate
{
    func sendDataBackToHomePageViewController(data: String?, data2: String)
    {
        
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            let tabItem = tabItems[3] as! UITabBarItem
            tabItem.image = UIImage.init(named: "notification_dotted")?.withRenderingMode(.alwaysOriginal)
            
        }
    }
    
    
    var pageController:UIPageViewController!
    private var arrVC:[UIViewController] = []
    
    var obj_location:location! = nil
    var obj_community:communityVC! = nil
    var obj_search:search! = nil
   
    @IBOutlet weak var menus_views: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        menus_views.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        menus_views.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        menus_views.layer.shadowOpacity = 1.0
        menus_views.layer.shadowRadius = 1
        menus_views.layer.masksToBounds = false
        
        self.createTabBarController()
        network_connectivity.message_delegate = self
        appDel.sendMessageDelegate = self
        
       
    }
   
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    func createTabBarController()
    {
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: 50+statusHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - 50 - statusHeight)
        }
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        obj_community = homeStoryboard.instantiateViewController(withIdentifier: "communityVC") as? communityVC
        obj_location = homeStoryboard.instantiateViewController(withIdentifier: "location") as? location
//      obj_search = homeStoryboard.instantiateViewController(withIdentifier: "search") as! search
        
        arrVC = [obj_community, obj_location]
        
        pageController.setViewControllers([obj_community], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
        
    }
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
           let index = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            if(index == 0)
            {
               
                btnMultipleUser.isSelected = true
                btn_location.isSelected = false
            }
            else if(index == 1)
            {
               
                btnMultipleUser.isSelected = false
                btn_location.isSelected = true
            }
            else
            {
               
                btnMultipleUser.isSelected = false
                btn_location.isSelected = false
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var btn_location: UIButton!
    @IBOutlet weak var btnMultipleUser: UIButton!
  
   
    @IBAction func btn_location(_ sender: Any)
    {
      
        btnMultipleUser.isSelected = false
        btn_location.isSelected = true
        
        pageController.setViewControllers([arrVC[1]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: {(Bool) -> Void in
        })
    }
   
    @IBAction func btnGroupUser(_ sender: Any)
    {
       
        btnMultipleUser.isSelected = true
        btn_location.isSelected = false
        
       // obj_community.getUpdatedDataForCommunity()
        
        pageController.setViewControllers([arrVC[0]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: {(Bool) -> Void in
        })
    
    }

    func setBack()
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    
    }
    
    func message_arrived()
    {
        
        print("messageRecieved")
        
        let unread_message = DBManager.shared.getTotalUnreadMessage(loginID: appDel.loginUserInfo.user_id!)
        let users = NSMutableArray()
        
        
        for i in 0..<unread_message.count
        {
            let client_id = (unread_message[i] as! NSDictionary).object(forKey: "sChatId") as? String ?? ""
            
            let resultPredicate = NSPredicate(format: "sChatId MATCHES %@", client_id)
            
            let isFound = users.filtered(using: resultPredicate)
            
            let dict = unread_message[i] as! NSDictionary
            
            if(isFound.count <= 0)
            {
                users.add(dict)
                
            }
            
        }
        
        
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            let tabItem = tabItems[1] as! UITabBarItem
            if(users.count > 0)
            {
                tabItem.badgeValue = "\(users.count)"
            }
            else
            {
                tabItem.badgeValue = nil
            }
            
        }
        
    }
   
    
}






