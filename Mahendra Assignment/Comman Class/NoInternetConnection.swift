//
//  NoInternetConnection.swift
//  Assignment
//
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class NoInternetConnection: UIViewController {
    
    @IBOutlet weak var btnConn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // calls on click refresh button
    @IBAction func btnConn(_ sender: Any)
    {
        
        // checks internet is available or not?
        let isNet =  WebServices.isConnectedToNetwork()
        if(isNet)
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.showToast(message: "No internet connection found")
        }
        
    }
    
}

