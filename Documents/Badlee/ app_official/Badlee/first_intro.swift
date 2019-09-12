//
//  first_intro.swift
//  Badlee
//
//  Created by Mahendra on 08/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class first_intro: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.imgView.frame = CGRect(x: self.imgView.frame.origin.x - 8, y: self.imgView.frame.origin.y, width: self.imgView.frame.width, height: self.imgView.frame.width)
            
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBAction func btnSlideShare(_ sender: Any) {
        
        self.performSegue(withIdentifier: "intoSegue", sender: nil)
    }
    
    @IBAction func swipe_method(_ sender: Any)
    {
        print("yes you got it")
        self.performSegue(withIdentifier: "intoSegue", sender: nil)
    }
    
}
