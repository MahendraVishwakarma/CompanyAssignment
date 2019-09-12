

import UIKit

class BadleeChat: NSObject
{
    var id:String?
    var message :String?
    var senderID:String?
    var receiverID:String?
    var type:String?
    
    static var sharedInstance = BadleeChat()
    private override init()
    {
        
    }
    
    

}
