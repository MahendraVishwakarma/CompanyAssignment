 //
//  web_services.swift
//  Badlee
//
//
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import AFNetworking


let app_secret_key = "vh4tyy74xAnNLtGagto4v4"//"fkgcdIIPdBg5poWfxfKV"
let app_id = "xYqBgc1Xcf2Ufyhir5abc4"//"wemeUlNjMm4s79KzRyjY"
var iscalledNo = 0

class web_services: NSObject
{
    
    class func isConnectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
    class func API_PostData(_ strURL: String, parameter para: NSDictionary, successClosure: @escaping (AnyObject?) -> (), failurClosure: @escaping (String?)-> ())
    {
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failurClosure("Please check internet connection");
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
    }
    
    class func badlee_get_with_authentication(page_url:String,username:String,password:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
       
        
        let request = AFHTTPRequestSerializer().request(withMethod: "GET", urlString: full_url, parameters: nil, error: nil)
        
         request.setValue(authData, forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
            request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        }
       

        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            succuss(data as AnyObject)
            
            }.resume();
        
        
    }
    
    
    class func badlee_post_with_authentication(page_url:String,username:String,password:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            
            failure("Please check internet connection" as AnyObject)
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        manager.requestSerializer.setValue(authData, forHTTPHeaderField: "Authorization")
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue(appDel.loginUserInfo.GGHTYLO4567WWERT, forHTTPHeaderField: "GGHTYLO4567WWERT")
        
        manager.post(full_url, parameters: nil, success: { requestOperation, response in
            
            NSLog("response data\(response)")
            
           
            do {
                
                let data = try? JSONSerialization.jsonObject(with: response as! Data, options: [])
                
                print(data ?? "no value")
                
                succuss(data as AnyObject)
                
            }
            
            
        }, failure: { requestOperation, error in
            failure("error.localizedDescription as AnyObject" as AnyObject)
            
            // NSLog("error\(error.localizedDescription)")
        })
    }
    
    class func badlee_delete_with_authentication(page_url:String,username:String,password:String, success:@escaping(AnyObject?) -> (), failure: @escaping(AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        let authStr =  username + ":" + password
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        manager.requestSerializer.setValue(authData, forHTTPHeaderField: "Authorization")
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue(appDel.loginUserInfo.GGHTYLO4567WWERT, forHTTPHeaderField: "GGHTYLO4567WWERT")
        manager.delete(full_url, parameters: nil, success: { requestOperation, response in
            
            NSLog("response data\(response)")
            
            
            do {
                
                let data = try? JSONSerialization.jsonObject(with: response as! Data, options: [])
                
                print(data ?? "no value")
                if(data != nil)
                {
                    success(data as AnyObject)
                    
                }
                else
                {
                    failure("failed" as AnyObject)
                }
                
                
            }

            
        }, failure: { requestOperation, error in
            failure("failed" as AnyObject)
            NSLog("error\(error.localizedDescription)")
        })
    }
    
    class func badlee_post_without_auth(page_url:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        

        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue(appDel.loginUserInfo.GGHTYLO4567WWERT, forHTTPHeaderField: "GGHTYLO4567WWERT")
        
        manager.get(full_url, parameters: nil, success: { requestOperation, response in
            
            NSLog("response data\(response)")
            
            
            do {
                
                let data = try? JSONSerialization.jsonObject(with: response as! Data, options: [])
                
                print(data ?? "no value")
                if(data != nil)
                {
                     succuss(data as AnyObject)
                }
                else
                {
                    failure("failed" as AnyObject)
                }
               
                
            }
//            catch let error
//            {
//                print(error)
//            }
            
        }, failure: { requestOperation, error in
            failure("failed" as AnyObject)
            NSLog("error\(error.localizedDescription)")
        })
    }
    
    
    class func badlee_post_with_authemtication_and_withSecretKey(page_url:String,username:String,password:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        let param = ["application_id":app_id,"application_secret":app_secret_key]
       

        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: full_url, parameters: param, error: nil)
       
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        request.addValue(authData, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
             request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        }
       
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            succuss(data as AnyObject)
            
            }.resume();
        
    }
    
    
    class func badlee_post_with_authemtication_and_withSecretKey_andParam(page_url:String,username:String,password:String,imgData:Data,imgURL:URL, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let full_url = StaticURLs.base_url + page_url
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        manager.requestSerializer.setValue(authData, forHTTPHeaderField: "Authorization")
        manager.requestSerializer.setValue(appDel.loginUserInfo.GGHTYLO4567WWERT, forHTTPHeaderField: "GGHTYLO4567WWERT")

        let param = ["application_id":app_id,"application_secret":app_secret_key]
        let dict = NSMutableDictionary()
        dict.addEntries(from: param)
        dict.setValue(imgData, forKey: "media")
        //dict.addEntries(from: par as! [AnyHashable : Any])
        
        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: full_url, parameters: dict, error: nil)

     
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            succuss(data as AnyObject)
            
            }.resume();
       
     
       
    }
    
    
    class
        func badlee_post_with_SecretKey(page_url:String,par:NSDictionary, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
      
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
         if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        let param = ["application_id":app_id,"application_secret":app_secret_key]
        let dict = NSMutableDictionary()
        dict.addEntries(from: param)
        dict.addEntries(from: par as! [AnyHashable : Any])
        
        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: full_url, parameters: dict, error: nil)
        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
            request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            if(data != nil)
            {
                succuss(data as AnyObject)
            }
            else
            {
                failure("something went wrong" as AnyObject)
            }
            
            
            }.resume();
        
        
    }
    
    class func badlee_get(page_url:String,isFuckingKey:Bool, success:@escaping (AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if( appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        
        let request = AFHTTPRequestSerializer().request(withMethod: "GET", urlString: full_url, parameters: nil, error: nil)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
           request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        }
        
    
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            success(data as AnyObject)
            
            }.resume();
        
    }
    
    
    
    class func badlee_getUserInfo(page_url:String,isFuckingKey:Bool, success:@escaping (AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
    
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        
        let request = AFHTTPRequestSerializer().request(withMethod: "GET", urlString: full_url, parameters: nil, error: nil)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
        {
            request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        }
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            success(data as AnyObject)
            
            }.resume();
        
    }
    
    
    
    class func badlee_getUsers(page_url:String,parama:NSArray,isFuckingKey:Bool, success:@escaping (AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        
        let request = NSMutableURLRequest(url: NSURL(string: full_url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
       
        let data = try? JSONSerialization.data(withJSONObject: parama, options: .prettyPrinted)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        
        let task = session.dataTask(with: URL.init(string: full_url)!) { (data, res, error) in
            
           print(res)
                
                if(error == nil)
                {
                   
                   
                    do {
                        if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? AnyObject
                        {
                            print(jsonData)
                            success(jsonData as AnyObject)
                        }
                        else
                        {
                            print("wrong json")
                        }
                        
                    } catch {
                        
                        failure("wrong json" as AnyObject)
                        
                    }
                   
                }
                else
                {
                    failure(error?.localizedDescription as AnyObject)
                }
           
        }
        
        task.resume()
        
        
    }
    
    class func badlee_change_password(page_url:String,username:String,password:String,newpassword:String, succuss:@escaping (AnyObject) ->(),failure:@escaping (AnyObject) ->())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
             web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
       
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        let param = ["application_id":app_id,"application_secret":app_secret_key,"password":newpassword]
        
        
        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: full_url, parameters: param, error: nil)
        
        //request.allHTTPHeaderFields = headers
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        request.addValue(authData, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            succuss(data as AnyObject)
            
            }.resume();
        //application/x-www-form-urlencoded
    }
    
    class func badlee_post_with_param(param:NSDictionary,page_url:String,username:String,password:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let sessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfiguration);
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
    
        let request = AFHTTPRequestSerializer().request(withMethod: "POST", urlString: full_url, parameters: param, error: nil)
         request.setValue(authData, forHTTPHeaderField: "Authorization")
        request.addValue(appDel.loginUserInfo.GGHTYLO4567WWERT!, forHTTPHeaderField: "GGHTYLO4567WWERT")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        manager.dataTask(with: request as URLRequest) { (response: URLResponse, data: Any, error: Error?) in
            
            if(error != nil)
            {
            
                NSLog((error?.localizedDescription)!)
                failure((error?.localizedDescription)! as AnyObject)
                return
            }
            
            
            succuss(data as AnyObject)
            
            }.resume();
        

    }
    
    class func badlee_postitem_with_param(param:NSDictionary,page_url:String,username:String,password:String, succuss:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
        let full_url = StaticURLs.base_url + page_url
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let authStr =  username + ":" + password
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        manager.requestSerializer.setValue(authData, forHTTPHeaderField: "Authorization")
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue(appDel.loginUserInfo.GGHTYLO4567WWERT, forHTTPHeaderField: "GGHTYLO4567WWERT")
        
        manager.post(full_url, parameters: param, success: { requestOperation, response in
            
            NSLog("response data\(response)")
            
            
            do {
                
                let data = try? JSONSerialization.jsonObject(with: response as! Data, options: [])
                
                print(data ?? "no value")
                
                succuss(data as AnyObject)
                
            }
            
            
        }, failure: { requestOperation, error in
            failure(error.localizedDescription as AnyObject)
             
            
            NSLog("error\(error.localizedDescription)")
        })
    }
    
    class func upload_image(page_url:String,uploading_image:UIImage,username:String?,password:String?, success:@escaping(AnyObject?) -> (), failure: @escaping (AnyObject?) -> ())
    {
        
        if(!isConnectedToNetwork())
        {
            openNoConnectionView()
            failure("Please check internet connection" as AnyObject);
            return
        }
        if(appDel.loginUserInfo.user_id != nil)
        {
            web_services.getUserInfo(userID: appDel.loginUserInfo.user_id!)
        }
        
         let full_url = StaticURLs.base_url + page_url
        let myUrl = NSURL(string: full_url);
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = ["application_id":app_id,"application_secret":app_secret_key]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let userName = username != nil ? username : "badlee"
        let passWord = password != nil ? password : "tattinahikari2saalseOMG!"
        
        let authStr =  userName! + ":" + passWord!
        
        let data = authStr.data(using: .utf8)
        let authData = "Basic \(data?.base64EncodedString() ?? "")"
        
        request.addValue(authData, forHTTPHeaderField: "Authorization")
        
        
        let imageData = UIImageJPEGRepresentation(uploading_image, 0.65)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "media", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            
            if error != nil {
              
                failure(error as AnyObject)
                return
            }
            
        
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
               success(json)
                
            
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
        
        

        
    }
    
    
  
    
    
   class func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
   class func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    class func playGIF()
    {

    }
    
    class func openNoConnectionView()
    {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let customReviewPopup = strbrd.instantiateViewController(withIdentifier: "noconnection") as! noconnection
        
        let presented_already = appDelegate.window?.viewWithTag(123456)
        
        if(presented_already == nil)
        {
            appDelegate.window?.rootViewController?.present(customReviewPopup, animated: true, completion: nil)
    
        }
        
        
        
    }
    
    class  func getUserInfo(userID:String)
    {
       
        iscalledNo = iscalledNo + 1
        if(iscalledNo > 1)
        {
            return
        }
        let page_url = "user.php?userid=" + appDel.loginUserInfo.user_id!;        web_services.badlee_post_without_auth(page_url: page_url, succuss: { (data) in
            
            comman.user_info = data as? NSDictionary
            iscalledNo = 0
            
        }) { (data) in
            appDel.window?.rootViewController?.showToast(message: "you've been logged out.")
            
            if(appDel.loginUserInfo.username != nil)
            {
                web_services.badlee_post_with_authentication(page_url: "logout.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
                    iscalledNo = 0
                    web_services.logoutuser()
                    
                }, failure: { (err) in
                    iscalledNo = 0
                    web_services.logoutuser()
                    
                })
            }
            else
            {
                iscalledNo = 0
                web_services.logoutuser()
            }
            
            
           
            
        }
           
    }

    class func logoutuser()
    {
        let dict :NSDictionary = ["user_id": "","user_name":"","isLogin": 0,"first_name":"","last_name":"","gender":"","birthday":"","city_id":"","interested":"","email":""]
        
        loginManager.setUserLogin(dict: dict)
        appDel.loginUserInfo.username = nil
        appDel.loginUserInfo.password = nil
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "logoutMessageVC") as! logoutMessageVC
        
        let presented_already = appDel.window?.viewWithTag(123456)
        
        if(presented_already == nil)
        {
            appDel.window?.rootViewController?.present(object, animated: true, completion: nil)
            
        }
        
        
    }
    

}
 
 extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
 }

