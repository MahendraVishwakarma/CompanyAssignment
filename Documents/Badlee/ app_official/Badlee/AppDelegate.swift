


import UIKit
import UserNotifications
import SwiftWebSocket
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let object_user_info = UserInfo()
    let loginUserInfo = loggedUserInfo()
    let logged_user_info = basic_logged_user_info()
    weak var sendMessageDelegate: TrendingProductsCustomDelegate?
    var badleeChatData = NSMutableArray()
    var chat_socket:WebSocket!
    var alert:Alert!
    var deviceToken = String()
    
    var nw_connection:network_connectivity!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        nw_connection = network_connectivity()
        registerForRichNotifications()
        UNUserNotificationCenter.current().delegate = self
        GIDSignIn.sharedInstance().clientID = "313606915067-i72240rundelu272h0rumc5m6e4s23d7.apps.googleusercontent.com"
        

       
       let userInfo = loginManager.isUserLogin()
       self.registerForRichNotifications()
       
       let center = UNUserNotificationCenter.current()
       center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
           
        }
        application.registerForRemoteNotifications()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = AppColor.themeColor
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let isCreate =  DBManager.shared.createDatabase()
        if(!isCreate)
        {
            NSLog("table is not created")
        }
        
        if((userInfo.object(forKey: "isLogin") as! Int) == 1)
        {
            self.setUserDefaultData(data: userInfo)
        }
        
        web_services.badlee_get(page_url: "fetch.php?request=places", isFuckingKey: false, success: { (data) in
            
           self.loginUserInfo.badlee_cities = data as? NSArray
        
        }) { (data) in
            
            
        }
        
        web_services.badlee_get(page_url: "fetch.php?request=categories", isFuckingKey: false, success: { (data) in
            
           // print(data)
              self.loginUserInfo.badlee_interests = data as? NSArray
            
        }) { (data) in
            
            
        }
        
         //SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
       return true//FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerForRichNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }
        
        //actions defination
        let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
        let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }

    
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
   
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let strURL = url.absoluteString
        if(strURL.contains("fb")){
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }else{
           return GIDSignIn.sharedInstance().handle(url)

        }
       
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let dt = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        
        print("deviceToken: \(dt)")
        
        self.deviceToken = dt
      
        NSLog("Mahendra = \(dt)")
    }
   

    func applicationWillResignActive(_ application: UIApplication)
    {
        //FBSDKAppEvents.activateApp()
        
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()

        center.removeAllDeliveredNotifications()
        
        if(loginUserInfo.user_id != nil)
        {
            comman.getUserInfo(userID: loginUserInfo.user_id!)
        }
        
        print(self.loginUserInfo.chat_username ?? "")
        
       
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        if(loginUserInfo.user_id != nil)
        {
            comman.getUserInfo(userID: loginUserInfo.user_id!)
        }
        if(self.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
            self.setup_connection(badleeID: self.loginUserInfo.GGHTYLO4567WWERT!)
        }
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
       
        NSLog("mahendra: \(userInfo)")
        
        let message_type = ((userInfo as NSDictionary).object(forKey: "aps") as? NSDictionary)?.object(forKey: "type") as? String ?? ""
        
        if(message_type != "message")
        {
             self.sendMessageDelegate?.sendDataBackToHomePageViewController(data: "", data2: "")
        }
        
        if (application.applicationState == .inactive)
        {
            let storybrd = UIStoryboard.init(name: "Main", bundle: nil)
            let object = storybrd.instantiateViewController(withIdentifier: "tabbarcontroller") as? tabbarcontroller
            
            if(message_type == "message")
            {
                
                let user_id = ((userInfo as NSDictionary).object(forKey: "aps") as? NSDictionary)?.object(forKey: "user_id") as? String ?? ""
                let arr = object?.viewControllers
                let chatObject  = arr![1] as? chatUserList
                object?.selectedIndex = 1
                window?.rootViewController = object
                window?.makeKeyAndVisible()
                
                let object = storybrd.instantiateViewController(withIdentifier: "messangerVC") as! messangerVC
                object.reciever_userID = user_id
                object.user_name = ""
                object.profile_image = UIImage.init(named: "user pic 1x")!
                chatObject?.present(object, animated: true, completion: nil)
                chatObject?.gotoChatBox(userID: user_id, user_name: "...", profileImage: UIImage.init(named: "user pic 1x")!)
                
                
            }
            
            
            if(message_type == "like" || message_type == "comment" || message_type == "follow")
            {
                
                object?.selectedIndex = 3
                window?.rootViewController = object
                window?.makeKeyAndVisible()
                
            }
        }
        
       
        
        
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {
        
        // do something with the notification
        NSLog("mahendrapush")
        //NSLog(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        let message_type = ((userInfo as NSDictionary).object(forKey: "aps") as? NSDictionary)?.object(forKey: "type") as? String ?? ""
        
        let storybrd = UIStoryboard.init(name: "Main", bundle: nil)
        let object = storybrd.instantiateViewController(withIdentifier: "tabbarcontroller") as? tabbarcontroller
        
        if(message_type == "message")
        {
            
            let user_id = ((userInfo as NSDictionary).object(forKey: "aps") as? NSDictionary)?.object(forKey: "user_id") as? String ?? ""
            let arr = object?.viewControllers
            let chatObject  = arr![1] as? chatUserList
            object?.selectedIndex = 1
            window?.rootViewController = object
            window?.makeKeyAndVisible()
            
            let object = storybrd.instantiateViewController(withIdentifier: "messangerVC") as! messangerVC
            object.reciever_userID = user_id
            object.user_name = ""
            object.profile_image = UIImage.init(named: "user pic 1x")!
            chatObject?.present(object, animated: true, completion: nil)
            chatObject?.gotoChatBox(userID: user_id, user_name: "...", profileImage: UIImage.init(named: "user pic 1x")!)
            
            
        }
        
        if(message_type == "like" || message_type == "comment" || message_type == "follow")
        {
            
            object?.selectedIndex = 3
            window?.rootViewController = object
            window?.makeKeyAndVisible()
            
        }
        
        
        // the docs say you should execute this asap
        return completionHandler()
    }
    
    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show alert while app is running in foreground
        print("mahendrapush2")
        
        return completionHandler(.sound)
    }
    
    //MARK: -xmpp delegate-
    func setup_connection(badleeID:String)
    {
        if(!(network_connectivity.isConnected ?? false)){
             nw_connection.setup_connection(badleeID: badleeID)
        }
       
    }
    
    func setUserDefaultData(data:NSDictionary)
    {
        
        
        if((data.object(forKey: "isLogin") as! Int) == 1)
        {
            
            self.loginUserInfo.first_name = (data.object(forKey: "first_name") as! String)
            self.loginUserInfo.last_name = (data.object(forKey: "last_name") as! String)
            self.loginUserInfo.user_id = (data.object(forKey: "user_id") as! String)
            self.loginUserInfo.gender = (data.object(forKey: "gender") as! String)
            self.loginUserInfo.interested = (data.object(forKey: "interested") as! String)
            self.loginUserInfo.city_id = (data.object(forKey: "city_id") as! String)
            self.loginUserInfo.birthday = data.object(forKey: "birthday") as? String
            self.loginUserInfo.email = data.object(forKey: "email") as? String
            self.loginUserInfo.password = data.object(forKey: "password") as? String
            self.loginUserInfo.username = data.object(forKey: "user_name") as? String
            self.loginUserInfo.GGHTYLO4567WWERT = data.object(forKey: "uid") as? String
           
           if(self.loginUserInfo.GGHTYLO4567WWERT != nil)
           {
             self.setup_connection(badleeID: self.loginUserInfo.GGHTYLO4567WWERT!)
           }
            
            
        }
        else
        {
            
        }
        
    }
    
   
    
    func registerForRichNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                //print(error?.localizedDescription ?? <#default value#>)
            }
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }
        
        //actions defination
        let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
        let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }
    
    
  
    func setDelegate(object:AnyObject)
    {
        
//        if(stream.isDisconnected() && loginUserInfo.chat_username != nil)
//        {
//            self.setup_connection(userID: loginUserInfo.chat_username!)
//        }
        
    }
    
    
}




