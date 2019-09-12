//
//  interested_catogories.swift
//  Badlee
//
//  Created by Mahendra on 30/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class interested_catogories: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    

    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableview: UITableView!
   // @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var mainView: UIView!
    var arrCat:NSArray? = nil
    var arrfilteredCat:Array? = []
    var selected_row:NSMutableArray!
    weak var customDelegateForDataReturn: TrendingProductsCustomDelegate?
    var selected_item = 0
    var selected_cat = ""
    var selected_catIDs = ""
    var isFrom:String!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainView.layer.shadowRadius = 2
        
        btnAdd.layer.shadowColor = UIColor.black.cgColor
        btnAdd.layer.shadowOpacity = 0.4
        btnAdd.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnAdd.layer.shadowRadius = 2
        btnAdd.layer.cornerRadius = 20
        
        comman.getCateogories { (categories) in
            self.arrCat =  categories as? NSArray
            self.arrfilteredCat = self.arrCat as? Array<Any> ?? []
            
            
            if(self.arrCat != nil && (self.arrCat?.count)! <= 0)
            {
                web_services.badlee_get(page_url: "fetch.php?request=categories", isFuckingKey: false, success: { (data) in
                    appDel.loginUserInfo.badlee_interests = data as? NSArray
                    self.tableview.reloadData()
                }) { (data) in
                    
                    
                }
            }
           
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        topCons.constant = UIScreen.main.bounds.height*0.59
        view.layoutIfNeeded()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        
        let view = touch?.view 
        
        if(view?.tag != 10)
        {
          self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrfilteredCat?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = cell.viewWithTag(11) as! UILabel
        let item_image = cell.viewWithTag(10) as! UIImageView
        let item_action = cell.viewWithTag(12) as! UIImageView
        
        let url = URL.init(string: (arrfilteredCat![indexPath.row] as! NSDictionary).object(forKey: "icon") as! String)
         let city_id = (arrfilteredCat![indexPath.row] as! NSDictionary).object(forKey: "id") as! Int
        
        if(selected_row.contains(city_id))
        {
            item_action.image = UIImage.init(named: "S_CB")
            name.textColor = AppColor.themeColor
        }
        else
        {
            item_action.image = UIImage.init(named: "US_CB")
            name.textColor = UIColor.black
        }
        
        if(url != nil)
        {
            item_image.setImageWith(url!, placeholderImage: UIImage.init(named: ""))
        }
        name.text = (arrfilteredCat![indexPath.row] as! NSDictionary).object(forKey: "name") as? String ?? ""
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
        let city_id = (arrfilteredCat![indexPath.row] as! NSDictionary).object(forKey: "id") as! Int;
        if(isFrom == "search")
        {
            selected_row.removeAllObjects()
        }
        if(selected_row.contains(city_id))
        {
            selected_row.remove(city_id)
        }
        else
        {
            selected_row.add(city_id)
        }
        tableview.reloadData()
        
    }
    
 
    @IBAction func btnAdd(_ sender: Any)
    {
        for  item in selected_row
        {
            let row:Int = item as! Int
            
            let filter = NSPredicate(format: "id == %i", row)
            let arr = arrCat!.filtered(using: filter)
            
            if(arr.count > 0)
            {
                if(Int(selected_cat.count) == 0)
                {
                    selected_cat = ((arr[0] as! NSDictionary).object(forKey: "name") as? String)!
                    selected_catIDs = "\(String(describing: (arr[0] as! NSDictionary).object(forKey: "id") as! Int))"
                }
                else
                {
                    selected_cat = selected_cat + ", " + ((arr[0] as! NSDictionary).object(forKey: "name") as? String)!
                    selected_catIDs = selected_catIDs + "," + "\(String(describing: (arr[0] as! NSDictionary).object(forKey: "id") as! Int))"
                }
            }
            
            
        }
        
        if(selected_cat.utf8CString.count > 5)
        {
            customDelegateForDataReturn?.sendDataBackToHomePageViewController(data: selected_cat, data2: selected_catIDs)
           
        }
         self.dismiss(animated: true, completion: nil)
    }
    

}
