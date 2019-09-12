//
//  tabbarcontroller.swift
//  Badlee
//
//  Created by Mahendra on 08/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class tabbarcontroller: UITabBarController {

    let btnHome = UIButton()
    let btnMessenger = UIButton()
    let btnNotification = UIButton()
    let btnProfile = UIButton()
    let postButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     // item.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
//        if let tabItems = self.tabBar.items as NSArray?
//        {
//            let tabItem = tabItems[3] as! UITabBarItem
//
//            //tabItem.image = UIImage.init(named: "notification_dotted")?.withRenderingMode(.alwaysOriginal)
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let tabItems = self.tabBar.items as NSArray?
        {
           let tabItem = tabItems[3] as! UITabBarItem
            
            if(item == tabItem)
            {
              //  tabItem.image = UIImage.init(named: "notification_dotted")
            }
        }
       
    }
    
    
    
    
}
