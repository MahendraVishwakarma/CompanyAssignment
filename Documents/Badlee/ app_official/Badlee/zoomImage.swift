//
//  zoomImage.swift
//  Badlee
//
//  Created by Mahendra on 26/05/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class zoomImage: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var scrollImg: UIScrollView!
    var imageSelected:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 2.0
        imageview.image = imageSelected
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    @IBAction func btnCross(_ sender: Any)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return self.imageview
    }

}
