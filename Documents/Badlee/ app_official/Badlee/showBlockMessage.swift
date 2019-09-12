//
//  showBlockMessage.swift
//  Badlee
//
//  Created by Mahendra on 02/06/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class showBlockMessage: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    var username:String?
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        lblName.text = username
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        headerView.layer.masksToBounds = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
