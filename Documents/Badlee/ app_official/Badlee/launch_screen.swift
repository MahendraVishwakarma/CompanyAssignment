//
//  launch_screen.swift
//  Badlee
//
//  Created by Mahendra on 09/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class launch_screen: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gifURL: String = "http://badlee.com/wp-content/uploads/2018/02/splash-screen.gif"
        let imageURL = UIImage.gifImageWithURL(gifURL)
        image.image  = imageURL
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
