//
//  LoginValidation.swift
//  loginValidation
//
//  Created by Arthonsys Technologies LLP on 15/05/17.
//  Copyright © 2017 Arthonsys Technologies LLP. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

let appDel = UIApplication.shared.delegate as! AppDelegate
 //let AppColor.themeColor:UIColor =  UIColor.init(red: 97.0/255.0, green: 18.0/255.0, blue: 101.0/255.0, alpha: 1)
var LOCAL_TIME_ZONE: Int { return TimeZone.current.secondsFromGMT() }

protocol shareDataDelagate: class
{
    func sendData(data: String?,city_id:String?)
}


extension String {
    func width(withConstrainedWidth height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.size.width
    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
       
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
class comman: NSObject
{
 
     static var user_info:NSDictionary!
     
    class func safeArea() -> UIEdgeInsets{
        let appDel = UIApplication.shared.delegate as! AppDelegate
        return (appDel.window?.rootViewController?.view.safeAreaInsets)!
    }
    
class func showAlert(_ alertTitle : String, _ alertMsg : String, _ view: UIViewController?)
{
        
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let actionOK : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alt) in
              //print("This is ok action");
        }
        alert.addAction(actionOK)
        
    view?.present(alert, animated: true, completion: nil)
        
    }
    
  
    
    class func showLoader(toView:UIViewController)
    {
        DispatchQueue.main.async {
            let object = MBProgressHUD.init(frame: toView.view.bounds)
            object.isSquare = false
            object.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            object.bezelView.layer.cornerRadius = 37
            object.bezelView.layer.masksToBounds = true
            object.areDefaultMotionEffectsEnabled = true
            object.contentColor = AppColor.themeColor
            object.show(animated: true)
            toView.view.addSubview(object)
            
        }
       
    
    }
    class func hideLoader(toView:UIViewController)
    {
        DispatchQueue.main.async {
            
             MBProgressHUD.hide(for: toView.view, animated: true)
        }
       
    }
    
   class func getIFAddresses() -> [String]
   {
        var addresses = [String]()
    
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
    
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next })
        {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
        
    }

class func checkEmail(_ email:String, _ view: UIViewController) -> Bool
{
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    if !emailTest.evaluate(with: email) {
       
        return false
    }
    
    return true
}

  class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    class func checkNull(_ textStr : String)-> Bool
    {
        
        let stripped = textStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Int(stripped.count) <= 0) {
            return true
        }
        return false
     }
    
    class func validateContact(_ textStr : String)-> Bool
    {
        
        let stripped = textStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Int(stripped.count) < 10 || Int(stripped.count) > 15)
        {
            return true
        }
        return false
    }
    
    class func getReaction(reactionName:String) -> UIImage
    {
        var img_reaction :UIImage!
        switch reactionName {
        case "1":
            img_reaction = UIImage.init(named: "lendandborrow prof pic 1x")
            break
        case "2" :
            img_reaction = UIImage.init(named: "show off 1x")
            break
        case "3" :
            img_reaction = UIImage.init(named: "shout profile pic 1x")
            break
        
        default:
            img_reaction = UIImage.init(named: "cross")
        }
        
        return img_reaction
    }
    
    class func daysBetweenDates(startDate: NSDate, endDate: NSDate, inTimeZone timeZone: TimeZone? = nil) -> String
    {
        
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour, .minute, .weekOfMonth])
        let anchorComponents = calendar.dateComponents(unitFlags, from: startDate as Date,  to: endDate as Date)

        if(anchorComponents.year! > 0)
        {
            if(anchorComponents.year! > 1)
            {
                return "\(anchorComponents.year!) years ago"
            }
            else
            {
                 return "a year ago"
            }
            
        }
        else if(anchorComponents.month! > 0)
        {
            if(anchorComponents.month! > 1)
            {
                return "\(anchorComponents.month!) months ago"
            }
            else
            {
                return "a month ago"
            }
        }
        else if(anchorComponents.weekOfMonth! > 0)
        {
            if(anchorComponents.weekOfMonth! > 1)
            {
                return "\(anchorComponents.weekOfMonth!) weeks ago"
            }
            else
            {
                return "a week ago"
            }
        }
        else if(anchorComponents.day! > 0)
        {
            if(anchorComponents.day! > 1)
            {
                return "\(anchorComponents.day!) days ago"
            }
            else
            {
                return "a day ago"
            }
        }
        else if(anchorComponents.hour! > 0)
        {
            if(anchorComponents.hour! > 1)
            {
                return "\(anchorComponents.hour!) hours ago"
            }
            else
            {
                return "an hour ago"
            }
        }
        else
        {
           
            if(anchorComponents.minute! > 1)
            {
                return "\(anchorComponents.minute!) minutes ago"
            }
            else
            {
                 return "few minutes ago"
            }
            
            
        }
        
        
        
    }
    
   class func dayDifference(from interval : TimeInterval) -> String
    {
       // let calendar = NSCalendar.current
        let epocTime = TimeInterval(interval) / 1000
        let date = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: date)
        
//        var today = ""
//        if calendar.isDateInYesterday(date)
//        {
//            today = "Yesterday"
//        }
//        else if calendar.isDateInToday(date)
//        {
//            today = "Today"
//        }
//        else if calendar.isDateInTomorrow(date)
//        {
//            today = "Tomorrow"
//        }
//        else
//        {
            //today = strDate

//        }
        
       
        return strDate
        
       
    }
    class func dayOfDate(from interval : TimeInterval) -> String
    {
         let calendar = NSCalendar.current
        let epocTime = TimeInterval(interval) / 1000
        let date = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: date)
        
                var today = ""
                if calendar.isDateInYesterday(date)
                {
                    today = "Yesterday"
                }
                else if calendar.isDateInToday(date)
                {
                    today = "Today"
                }
                else if calendar.isDateInTomorrow(date)
                {
                    today = "Tomorrow"
                }
                else
                {
                     today = strDate
        
                }
        
        
        return today
        
        
    }
    
    class func timeAndDate(startDate: NSDate, endDate: NSDate,timestamp:Int64, inTimeZone timeZone: TimeZone? = nil) -> String
    {
        
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let unitFlags = Set<Calendar.Component>([.day, .month,.year, .hour, .minute])
        let anchorComponents = calendar.dateComponents(unitFlags, from: startDate as Date,  to: endDate as Date)
        
      
       if(anchorComponents.month! > 0 || anchorComponents.day! > 1 || anchorComponents.year! > 0)
        {
            let epocTime = TimeInterval(timestamp) / 1000
            let date = Date.init(timeIntervalSince1970: epocTime)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
           // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd MMM yyyy"
            let strDate = dateFormatter.string(from: date)
            
            return strDate
            
        }
       
        else if( anchorComponents.hour! > 1)
        {
            let epocTime = TimeInterval(timestamp) / 1000
            let date = Date.init(timeIntervalSince1970: epocTime)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            
            // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd"
            let strDate = dateFormatter.string(from: startDate as Date)
            let strToday = dateFormatter.string(from: endDate as Date)
            
            if(Int(strDate)! < Int(strToday)!)
            {
                return "YESTERDAY"
            }
            else
            {
                dateFormatter.dateFormat = "hh:mm a"
                let strDate = dateFormatter.string(from: date)
                
                return strDate
            }
           
        }
        else
        {
            let epocTime = TimeInterval(timestamp) / 1000
            let date = Date.init(timeIntervalSince1970: epocTime)
            let dateFormatter = DateFormatter()
           // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "hh:mm a"
            let strDate = dateFormatter.string(from: date)
            
            return strDate
        }
        
        
    }
    
    class func getCateogories( succuss:@escaping(AnyObject?) -> ())
    {
       succuss(appDel.loginUserInfo.badlee_interests)
    }
    
    class func getCategoryName(ids:String) -> String
    {
        let interests = ids.components(separatedBy: ",") as NSArray
        
        var interest_name:String = ""
        
        if(appDel.loginUserInfo.badlee_interests != nil)
        {
            if(interests.count == 0)
            {
                return ""
            }
            
            for item in interests
            {
                let id:Int = Int((item as! NSString).intValue)
                
                
                if(id > 0)
                {
                    let jsonResult:NSArray = appDel.loginUserInfo.badlee_interests!
                    let filter = NSPredicate(format: "id == %i",id)
                    let result = jsonResult.filtered(using: filter)
                    if(result.count > 0)
                    {
                        if(interest_name.count <= 1)
                        {
                            interest_name = "\((result[0] as! NSDictionary).object(forKey: "name") as! String)"
                        }
                        else
                        {
                            interest_name = interest_name + " ," + "\((result[0] as! NSDictionary).object(forKey: "name") as! String)"
                        }
                        
                    }
                }
               
               
            }
        }
        
        return interest_name
    }
    
    class func getInterestInfo(id:String) -> NSDictionary
    {
        let id_item:Int = Int((id as NSString).intValue)
        
        var interest_info = NSDictionary()
        
        if(id_item > 0)
        {
            let jsonResult:NSArray = appDel.loginUserInfo.badlee_interests!
            let filter = NSPredicate(format: "id == %i",id_item)
            let result = jsonResult.filtered(using: filter)
            if(result.count > 0)
            {
                    interest_info = (result[0] as! NSDictionary)
                
            }
        }
        
        return interest_info
    }
    
    class func getCityName(name:String) -> String
    {
       if(appDel.loginUserInfo.badlee_cities != nil)
       {
        if(Int(name) == nil)
        {
            return ""
        }
        
        let jsonResult:NSArray = appDel.loginUserInfo.badlee_cities!
        let filter = NSPredicate(format: "id == %i",Int(name)!)
        let result = jsonResult.filtered(using: filter)
        if(result.count != 0)
        {
            return (result[0] as! NSDictionary).object(forKey: "city") as! String
        }
        
        }
        else
       {
        web_services.badlee_get(page_url: "fetch.php?request=places", isFuckingKey: false, success: { (data) in
            
            appDel.loginUserInfo.badlee_cities = data as? NSArray
            
        }) { (data) in
            
            
        }
        
        web_services.badlee_get(page_url: "fetch.php?request=categories", isFuckingKey: false, success: { (data) in
            
            appDel.loginUserInfo.badlee_interests = data as? NSArray
            
        }) { (data) in
            
            
        }
        
        }
        
        return ""
        
    }
    
    class func checking_my_like(data:NSArray) ->Bool
    {
        let filter = NSPredicate(format: "user_id contains[cd] %@", appDel.loginUserInfo.user_id!)
        let isGot = data.filtered(using: filter)
        if(isGot.count > 0)
        {
            return true
        }
        return false
    }
    
    class func checkusername(username:String) -> Bool
    {
        let usernameRegEx = "[A-Z0-9a-z._]{3,15}"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        if !usernameTest.evaluate(with: username) {
            
            return false
        }
        
        return true
    }
    
    class func filterData_by_Reaction(fromArray:NSArray, reaction_name:String) -> NSArray
    {
        let filter = NSPredicate(format: "purpose == %@",reaction_name)
        let result = fromArray.filtered(using: filter)
        return result as NSArray
    }

    class func getTimeStamp() -> Int64
    {
        
      let timestamp = Date().millisecondsSince1970
      return timestamp
        
    }
    class func timestamp_to_date(timestamp:Int64) -> String
    {
        let epocTime = TimeInterval(timestamp) / 1000
        let date = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    class func timestamp_to_time(timestamp:Int64) -> String
    {
        let epocTime = TimeInterval(timestamp) / 1000
        let date = Date.init(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    class func sortArraybyTimestamp(arr:NSArray) -> NSArray
    {
        return arr.ascendingArrayWithKeyValue(key: "postId")
    }
    
   class func convertString_to_image(strData:String) -> UIImage
    {
        let data = Data(base64Encoded: strData, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: data)
        
        return decodedimage!
    }
    
    class func convertImage_to_string(selected_image: UIImage) -> String
    {
        
        let imageData = UIImagePNGRepresentation(selected_image)
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        return (strBase64 != nil ? strBase64! : "")
    }
    class func getUserInfo(userID:String)
    {
        let page_url = "user.php?userid=" + appDel.loginUserInfo.user_id!;        web_services.badlee_post_without_auth(page_url: page_url, succuss: { (data) in
            
            comman.user_info = data as? NSDictionary
            
        }) { (data) in
            
        }
        
    }
    
    class func checkPermission(reciever_userID:String) ->Bool
    {
        if(comman.user_info != nil)
        {
            let user_Meblocked = comman.user_info.object(forKey: "block_me") as? NSArray ?? []
            
            let user_Iblocked = comman.user_info.object(forKey: "i_block") as? NSArray ?? []
            
            let MeBlocked = NSPredicate(format: "user_id like %@",appDel.loginUserInfo.user_id!);
            
            let iBlocked = NSPredicate(format: "user_id like %@", reciever_userID);
            
            let isIamBlocked = user_Meblocked.filter { MeBlocked.evaluate(with: $0) };
            print(isIamBlocked)
            
            let isIBlocked = user_Iblocked.filter { iBlocked.evaluate(with: $0) };
            print(isIBlocked)
            
            var user_blocked = false
            if(isIamBlocked.count > 0)
            {
                user_blocked = true
            }
            else if(isIBlocked.count > 0)
            {
                user_blocked = true
            }
            
            
            return user_blocked
            
        }
        return false
        
        
    }
    
    class func isItemAvailable(arr:NSArray, postID:String) ->Bool
    {
        let check = NSPredicate(format: "id == %i", Int(postID)!)
    
        let isAvailable = arr.filtered(using: check)
  
        if(isAvailable.count > 0)
        {
            return true
        }
       
        return false
    }
    
    class func isUserAvailable(arr:NSArray, postID:String) ->Bool
    {
       
        let check = NSPredicate(format: "user_id contains[cd] %@", postID)
        
        let isAvailable = arr.filtered(using: check)
        
        if(isAvailable.count > 0)
        {
            return true
        }
        
        return false
    }
    
    class func isAdded(user_id:String) -> String
    {
        var  isLareadyAdded = false
        let arrFollowers = comman.user_info.object(forKey: "following") as? NSArray ?? []
        
        for dict in arrFollowers {
            
            let user_id1 = (dict as! NSDictionary).object(forKey: "user_id") as! String
            
            if(user_id == user_id1)
            {
                isLareadyAdded = true
                break
            }
        }
        
        if(isLareadyAdded)
        {
            return "ADDED"
        }
        else
        {
            return "ADD"
        }
    }
}
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x:0,y:0,width:self.size.width, height:self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}


extension CAGradientLayer {
    
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    convenience init(point:Point) {
        self.init()
        
        self.colors = [comman.hexStringToUIColor(hex: "#9f307f").cgColor, comman.hexStringToUIColor(hex: "#e77652").cgColor]
        self.locations = [0.0 , 1.0]
        self.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.endPoint = CGPoint(x: 1.0, y: 0.5)
        
    }
   
}

extension NSArray{
    //sorting- ascending
    func ascendingArrayWithKeyValue(key:String) -> NSArray{
        let ns = NSSortDescriptor.init(key: key, ascending: true)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
    
    //sorting - descending
    func discendingArrayWithKeyValue(key:String) -> NSArray{
        let ns = NSSortDescriptor.init(key: key, ascending: false)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
}


