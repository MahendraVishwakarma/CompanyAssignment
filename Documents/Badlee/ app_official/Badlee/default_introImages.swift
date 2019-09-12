//
//  default_introImages.swift
//  Badlee
//
//  Created by Mahendra on 09/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class default_introImages: NSObject
{
   static var image_first:UIImage?
   static var image_second:UIImage?
   static var image_third:UIImage?
    
    class func download_image()
    {
        
        if(web_services.isConnectedToNetwork())
        {
            
            let gifURL1 : String = "http://badlee.com/wp-content/uploads/2018/02/Scr-1.gif"
            let imageURL1 = UIImage.gifImageWithURL(gifURL1)
            
            image_first  = UIImageView(image: imageURL1).image != nil ? UIImageView(image: imageURL1).image : UIImage.init(named: "landing_1")
            
            let gifURL2 : String = "http://badlee.com/wp-content/uploads/2018/02/Scr-2.gif"
            let imageURL2 = UIImage.gifImageWithURL(gifURL2)
            image_second  = UIImageView(image: imageURL2).image != nil ? UIImageView(image: imageURL2).image : UIImage.init(named: "landing_2")
            
            let gifURL3 : String = "http://badlee.com/wp-content/uploads/2018/02/Scr-3.gif"
            let imageURL3 = UIImage.gifImageWithURL(gifURL3)
            image_third  = UIImageView(image: imageURL3).image != nil ? UIImageView(image: imageURL3).image : UIImage.init(named: "landing_3")
            
            
        }
        else
        {
            image_first = UIImage.init(named: "landing_1")
            image_second = UIImage.init(named: "landing_2")
            image_third = UIImage.init(named: "landing_3")
        }
       
        
    }
    class func getImage() -> (imgaes_1:UIImage,image_2:UIImage,image_3:UIImage)
    {
        return ((image_first == nil ? UIImage.init(named: "landing_1") : image_first)! , (image_second == nil ? UIImage.init(named: "landing_2") : image_second)!, (image_third == nil ? UIImage.init(named: "landing_3") : image_third)!)
    }
    
    

}
