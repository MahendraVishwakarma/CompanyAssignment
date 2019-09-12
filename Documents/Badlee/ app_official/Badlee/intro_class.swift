//
//  intro_class.swift
//  Badlee
//
//  Created by Mahendra on 26/11/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit


class intro_class: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var image_first: UIImageView!
    
    @IBOutlet weak var btnBsdlee: UIButton!
    @IBOutlet weak var image_third: UIImageView!
    @IBOutlet weak var image_second: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    var timer : Timer!
    @IBOutlet weak var btnView: UIView!
    var time = 0
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let images = default_introImages.getImage()
        image_first.image = images.imgaes_1
        image_second.image  = images.image_2
        image_third.image = images.image_3
        
        btnView.layer.shadowColor = UIColor.black.cgColor
        btnView.layer.shadowOpacity = 0.7
        btnView.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnView.layer.shadowRadius = 3
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update_offset), userInfo: nil, repeats: true)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        progress.progress = Float(CGFloat(time + 1) * 0.334)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        scrollview.contentSize = CGSize(width:UIScreen.main.bounds.width*3, height:0)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollview.contentOffset.x / scrollview.frame.size.width)
        
        if(pageNumber >= 2)
        {
            timer.invalidate()
            self.perform(#selector(stopImageAnimation), with: nil, afterDelay: 4)
        }
        
        progress.progress = Float(CGFloat(pageNumber + 1) * 0.334)
        
    }

    @IBAction func btn_proceed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "login_segue", sender: nil)
    }
    
    @objc func update_offset()
    {
        time = time + 1
        let  x_ori =  CGFloat(time)*UIScreen.main.bounds.width
        
        scrollview.setContentOffset(CGPoint.init(x:x_ori, y: 0), animated: true)
        progress.progress = Float(CGFloat(time + 1) * 0.334)
        
        if(time == 2)
        {
            timer.invalidate()
            self.perform(#selector(stopImageAnimation), with: nil, afterDelay: 4)
        }
        
    }
    
    @objc func stopImageAnimation()
    {
        image_first.image = UIImage.init(named: "landing_1")
        image_second.image = UIImage.init(named: "landing_2")
        image_third.image = UIImage.init(named: "landing_3")
    }
    
}
