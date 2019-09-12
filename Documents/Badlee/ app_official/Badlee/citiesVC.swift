//
//  citiesVC.swift
//  Badlee
//
//  Created by Mahendra on 30/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class citiesVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var listTop: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    var arrCities = NSArray()
    var arrfilteredCities = Array<Any>()
    weak var shareDataDelegate: shareDataDelagate?
    @IBOutlet weak var search_text: UISearchBar!
    var selected_city_id:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getCities()
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 2
        tableview.tableFooterView = UIView.init(frame: .zero)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        listTop.constant = UIScreen.main.bounds.height*0.38
        view.layoutIfNeeded()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getCities()
    {
        if(appDel.loginUserInfo.badlee_cities != nil)
        {
            arrCities = appDel.loginUserInfo.badlee_cities!
            arrfilteredCities = (arrCities as? Array<Any>)!
            self.tableview.reloadData()
        }
       
        
        if((arrCities.count) <= 0)
        {
            
            web_services.badlee_get(page_url: "fetch.php?request=places", isFuckingKey: false, success: { (data) in
                
                appDel.loginUserInfo.badlee_cities = data as? NSArray
                self.arrCities = appDel.loginUserInfo.badlee_cities!
                self.arrfilteredCities = (self.arrCities as? Array<Any>)!
                self.tableview.reloadData()
                
            }) { (data) in
                
                
            }
            
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        let view = touch?.view
        
        if(view?.tag != 10)
        {
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrfilteredCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
       let city_id = String((arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "id") as! Int)
        
        if(city_id == selected_city_id)
        {
            cell.textLabel?.textColor = AppColor.themeColor
            cell.imageView?.image = UIImage.init(named: "small_oin")
        }
        else
        {
           cell.textLabel?.textColor = UIColor.black
           cell.imageView?.image = UIImage.init(named: "pin")
        }
        
        cell.textLabel?.text = String(describing: (arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "city")! as! String) + ",  " +  String(describing: (arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "state") as! String)
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selected_city = ((arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "city") as! String) + ", " + ((arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "state") as! String)
        
         selected_city_id = String((arrfilteredCities[indexPath.row] as! NSDictionary).object(forKey: "id") as! Int)
        
        
        shareDataDelegate?.sendData(data: selected_city, city_id: selected_city_id)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_cross(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(Int(searchText.count) > 0)
        {
            let filter = NSPredicate(format: "city BEGINSWITH[cd] %@", searchText)
            arrfilteredCities = arrCities.filtered(using: filter)
        }
        else
        {
            arrfilteredCities = (arrCities as? Array<Any>)!
        }
        
        self.tableview.reloadData()
        
    }
    

}
