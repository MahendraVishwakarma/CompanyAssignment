//
//  basic_user_info.swift
//  Badlee
//
//  Created by Mahendra on 12/01/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class basic_logged_user_info: NSObject
{
   // var user_name:String?
   // var password:String?
    
}

class chatData:NSObject
{
     var username:String?
     var sender_name: String?
     var item_description: String?
     var message:String?
     var message_type:String?
     var timestamp:String?
     var image_url:String?
     var item_owner : String?
    
    
    convenience init(_ attributes: [AnyHashable: Any])
    {
         self.init()
        
        username =          attributes["senderId"] as? String
        message =           attributes["message"] as? String
        message_type =      attributes["message_type"] as? String
        timestamp =         "\(String(describing: attributes["timestamp"]!))"
        image_url =         attributes["image_url"] as? String
        sender_name =       attributes["senderName"] as? String
        item_description =  attributes["item_description"] as? String
        item_owner =        attributes["item_owner"] as? String
        
    }
    
}


class CopyableLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    @objc func showMenu(sender: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}
