//
//  UserID.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 06/12/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class UserID: NSObject {
    var user_id:String!
    var user_name:String!
    
     init(userid:String, username:String) {
        super.init()
        self.user_id = userid
        self.user_name = username
    }

}
