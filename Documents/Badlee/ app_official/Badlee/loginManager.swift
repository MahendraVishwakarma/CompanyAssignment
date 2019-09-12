//
//  loginManager.swift
//  Badlee
//
//  Created by Mahendra on 22/01/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class loginManager: NSObject
{
   static let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
  static let fileManager = FileManager.default
    
    class func setUserLogin(dict:NSDictionary)
    {
        let dataUser: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
       
        UserDefaults.standard.set(dataUser, forKey: "userinfo")
        UserDefaults.standard.synchronize()
        
    }
    
    class func isUserLogin() -> NSDictionary
    {
      
        let userInfo = NSMutableDictionary()
        
        if(UserDefaults.standard.object(forKey: "userinfo") != nil)
        {
            let userData = UserDefaults.standard.data(forKey: "userinfo")
            
            let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: userData!) as? [String : Any]
            userInfo.addEntries(from: dictionary!)
            
        }
        else
        {
            userInfo.setValue(0, forKey: "isLogin")
        }
        
        return userInfo
    }
    
}
