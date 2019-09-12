//
//  datepicker.swift
//  Badlee
//
//  Created by Mahendra on 29/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

protocol TrendingProductsCustomDelegate: class
{
    func sendDataBackToHomePageViewController(data: String?,data2:String)
    
}

class datepicker: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var datepicker: UIDatePicker!
    var selected_date:String!
    weak var customDelegateForDataReturn: TrendingProductsCustomDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: Date = Date()
        let components: NSDateComponents = NSDateComponents()
        components.year = -150
        let minDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        components.year = -1
        let maxDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        self.datepicker.minimumDate = minDate
        self.datepicker.maximumDate = maxDate
        
        btnCancel.layer.shadowColor = UIColor.black.cgColor
        btnCancel.layer.shadowOpacity = 0.8
        btnCancel.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnCancel.layer.shadowRadius = 3
        btnCancel.layer.cornerRadius = 20
        
        btnDone.layer.shadowColor = UIColor.black.cgColor
        btnDone.layer.shadowOpacity = 0.8
        btnDone.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnDone.layer.shadowRadius = 3
        btnDone.layer.cornerRadius = 20
        
        if(selected_date != nil && selected_date.count > 5)
        {
             self.setPreDate(strDate: selected_date)
        }
       
    
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnDone(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: datepicker.date)
        customDelegateForDataReturn?.sendDataBackToHomePageViewController(data: dateString, data2: "")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPreDate(strDate:String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let dt = dateFormatter.date(from: strDate)
        datepicker.date = dt!
    }
    @IBAction func btn_Cancel(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    

}
