//
//  term_condition.swift
//  Badlee
//
//  Created by Mahendra on 06/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import MBProgressHUD

class term_condition: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

       
        let url = URL.init(string: StaticURLs.privacy_policy)
        let request = URLRequest.init(url: url!)
        
        webview.loadRequest(request)
        webview.delegate = self
        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: webView, animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: webView, animated: true)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hide(for: webView, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnBAck(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
