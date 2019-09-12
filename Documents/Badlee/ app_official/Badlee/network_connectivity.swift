//

//

import UIKit
import SwiftWebSocket

protocol chatparant:class
{
    func message_sent(data:NSDictionary)
    func message_recieved(data:NSDictionary)

}

protocol infor_notification:class {
    func message_arrived()
}

protocol update_userlist:class {
    func message_arrived()
}

class network_connectivity: NSObject,WebSocketDelegate,AlertDelegate
{
   static var parantDelegate:chatparant!
   static var message_delegate:infor_notification!
   static var update_delegate:update_userlist!
   static var isReeading:Bool!
   static var isConnected:Bool? = false
   static var client_userID:String!
   static var message_sent:String!
    var timer:Timer!
    
    func setup_connection(badleeID:String)
    {
        network_connectivity.isConnected = true
        print("connecting....")//8055//1089
        appDel.chat_socket = WebSocket.init("ws://chat.badlee.com:1089?\(badleeID)")
        appDel.chat_socket.delegate = self
        appDel.chat_socket.services = [.VoIP, .Background]
        appDel.chat_socket.open()
        
    }
    
    
    func webSocketOpen()
    {
        network_connectivity.isConnected = true
        if(timer != nil)
        {
            timer.invalidate()
        }
        print("open is called")
        
        
    }
    
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool)
    {
         network_connectivity.isConnected = false
        
            DispatchQueue.main.async {
                
                
                self.timer = nil
                self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                    
                    if(!network_connectivity.isConnected!)
                    {
                        
                        self.setup_connection(badleeID: appDel.loginUserInfo.GGHTYLO4567WWERT!)
                    }
                    else{
                        self.timer.invalidate()
                    }
                }
          
        }
         print("close is called")
        
    }
   
    
    func webSocketError(_ error: NSError)
    {
        print("error is called\(error.localizedDescription)")
        network_connectivity.isConnected = false
    }
    func webSocketPong()
    {
         print("pong is called")
    }
    func webSocketMessageData(_ data: Data)
    {
        print(data)
        
    }
    
   
    
    func scheduleNotifications(username:String,message:String,url:String) {
        
        appDel.alert = Alert.init(title: username, message: message, url: url, duration: 0.5, completion: nil)
        appDel.alert.delegate = self
        appDel.alert.alertType = .success
        appDel.alert.incomingTransition = .slideFromTop
        appDel.alert.outgoingTransition = .slideToTop
        appDel.alert.bounces = true
        appDel.alert.show()
        
        
    }
    
    func webSocketMessageText(_ text: String)
    {
        let data = text.data(using: .utf8)!
        
            do
            {
                let json =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if(json != nil)
                {
                    print("it is dic")
                    let data = (json as NSDictionary?)?.object(forKey: "data") as? NSDictionary ?? [:]
                    
                   
                    
                    if((data.object(forKey: "id") as? String ?? "").count > 1)
                    {
                        let messageID = data.object(forKey: "id") as? String ?? ""
                        let isMessageAvail = DBManager.shared.isMessageAlreadyPresent(messageID: messageID)
                        if(isMessageAvail){
                            return
                        }
                        
                        let field_message_id = data.object(forKey: "id") as? String ?? ""
                        let field_message =  (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "msg") as? String ?? ""
                        let field_sChatId = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "sChatId") as? String ?? ""
                        let field_rChatId = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "rChatId") as? String ?? ""
                        let field_msgType = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "msgType") as? String ?? ""
                        let field_imgUrl = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "imgUrl") as? String ?? ""
                        let field_postId = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "postId") as? String ?? ""
                        let field_timestamp = data.object(forKey: "timestamp")as? Int64 ?? 0
                        let field_pUserId = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "pUserId") as? String ?? ""
                        let field_reference = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "reference") as? String ?? ""
                        let field_sName = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "sName") as? String ?? ""
                        let field_sProfile_url = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "sProfile_url") as? String ?? ""
                        let field_rName = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "rName") as? String ?? ""
                        let field_rProfile_url = (data.object(forKey: "message")as? NSDictionary)?.object(forKey: "rProfile_url") as? String ?? ""
                    
                        let day = comman.dayDifference(from:TimeInterval(field_timestamp) )
                        
                        network_connectivity.sendMessageRecievedAck(msgId: (data.object(forKey: "id") as? String ?? ""))
                        if(network_connectivity.parantDelegate != nil && network_connectivity.isReeading == true && (network_connectivity.client_userID == field_sChatId || field_sChatId == appDel.loginUserInfo.user_id! ))
                        {
                            let field_status = "1"
                            let loadData = ["message_id":field_message_id,"message":field_message,"sChatId":field_sChatId,"rChatId":field_rChatId,"msgType":field_msgType,"imgUrl":field_imgUrl,"postId":field_postId,"timestamp":field_timestamp,"pUserId":field_pUserId,"reference":field_reference,"sName":field_sName,"sProfile_url":field_sProfile_url,"rName":field_rName,"rProfile_url":field_rProfile_url,"status":field_status,"day":day] as [String : Any]
                            
                            DBManager.shared.insertData(_message_id: field_message_id, _message: field_message, _rChatId: field_rChatId, _rName: field_rName, _rProfile_url: field_rProfile_url, _timestamp: field_timestamp, _image_url: field_imgUrl, _status: field_status, _message_type: field_msgType, _sName: field_sName, _sChatId: field_sChatId, _sProfile_url: field_sProfile_url, _postId: field_postId, _pUserId: field_pUserId, _reference: field_reference)
                            
                            network_connectivity.parantDelegate.message_sent(data: loadData as NSDictionary)
                            print(data)
                            
                        }
                        else
                        {
                            let field_status = "0"
                        
                            DBManager.shared.insertData(_message_id: field_message_id, _message: field_message, _rChatId: field_rChatId, _rName: field_rName, _rProfile_url: field_rProfile_url, _timestamp: field_timestamp, _image_url: field_imgUrl, _status: field_status, _message_type: field_msgType, _sName: field_sName, _sChatId: field_sChatId, _sProfile_url: field_sProfile_url, _postId: field_postId, _pUserId: field_pUserId, _reference: field_reference)
                            
                            if(network_connectivity.message_delegate != nil)
                            {
                                network_connectivity.message_delegate.message_arrived()
                            }
                            if(network_connectivity.update_delegate != nil)
                            {
                                network_connectivity.update_delegate.message_arrived()
                            }
                            
                            if(field_sChatId != appDel.loginUserInfo.user_id!)
                            {
                                
                                web_services.badlee_getUserInfo(page_url: "user.php?userid=\(field_sChatId)&sort=true", isFuckingKey: true, success: { (data) in
                                    
                                    let strURL = (data as? NSDictionary)?.object(forKey: "avatar") as? String ?? ""

                                    let profile_url  = StaticURLs.base_url + strURL
                                    
                                    let name = ((data as? NSDictionary)?.object(forKey: "fname") as? String ?? "") + " " + ((data as? NSDictionary)?.object(forKey: "lname") as? String ?? "")
                                    self.scheduleNotifications(username:name , message: field_message, url: profile_url)
                                    
                                }) { (error) in
                                    
                                 
                                }
                                
                            }
                            
                        }
                        
                    }
                    network_connectivity.isConnected = true
                    
                }
                
                print(json!)
            }
            catch
            {
                print(error.localizedDescription)
            }
        
    }
    
    func webSocketEnd(_ code: Int, reason: String, wasClean: Bool, error: NSError?)
    {
        network_connectivity.isConnected = false
    }
    
    class func send_message(msg:String,msgType:String,rUserId:String,sUserId:String,imgUrl:String,postId:String,pUserId:String, object:UIViewController?)
    {
        let param = ["msg":msg,"msgType":msgType,"rChatId":rUserId,"sChatId":sUserId,"imgUrl":imgUrl,"postId":postId,"pUserId":pUserId]
        self.send_messageTOserver(param: param, object: object)
    
    }
    
   class func send_messageTOserver(param:Dictionary<String, Any>,object:UIViewController?)
    {
        do
        {
            
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
           
            if(network_connectivity.isConnected)!
            {
                 appDel.chat_socket.send(jsonString)
            }
            else
            {
                if(appDel.loginUserInfo.GGHTYLO4567WWERT != nil)
                {
                    appDel.nw_connection.setup_connection(badleeID: appDel.loginUserInfo.GGHTYLO4567WWERT!)
                }
                
                comman.showAlert("Error", "something went wrong, please try again",object)
            }
        
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
   class func sendMessageRecievedAck(msgId:String)
    {
        if(msgId.count > 5)
        {
            let param = ["type":"ack","id":msgId]
            send_messageTOserver(param: param, object: nil)
        }
    }
    
}

