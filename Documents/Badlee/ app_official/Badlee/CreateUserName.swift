//
//  CreateUserName.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 12/09/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class CreateUserName: UIViewController,shareDataDelagate {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var lblCoutryName: UITextField!
    @IBOutlet weak var view_first: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var welcomeName: UILabel!
    var user_info:UserInfo?
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func btnSelectLocation(_ sender: Any) {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        
        let object = strbrd.instantiateViewController(withIdentifier: "citiesVC") as! citiesVC
        object.shareDataDelegate = self
        object.selected_city_id = user_info?.city_id
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.present(object, animated: true, completion: nil)
    }
    func sendData(data: String?, city_id: String?)
    {
        user_info?.city_id  = city_id
        user_info?.city = data
        lblCoutryName.text = data
        
    }
    @IBAction func btnaenterBadlee(_ sender: Any) {
        
    }
    
    @IBAction func btnTips(_ sender: Any) {
        let storybrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = storybrd.instantiateViewController(withIdentifier: "tipsVC") as! tipsVC
        self.present(object, animated: true, completion: nil)
    }
    
}
