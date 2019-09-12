//
//  ImageCompression.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 28/07/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

class ImageCompression{
    var currentSize:Int = 0
    var preSize:Int = 0
    
     func imageCompression(image:UIImage) -> (UIImage,Bool){
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        let imageSize: Int = imageData?.count ?? 0
        let imageKBSize = imageSize/1000
        currentSize = imageKBSize
        if(imageKBSize > 500){
            if let compressedImgData = UIImageJPEGRepresentation(image, 0.9){
                let compressedImage = UIImage(data: compressedImgData)
                if(preSize == currentSize){
                    if(currentSize < 500){
                        return (image, false)
                    }
                    return (image, true)
                }
                preSize = currentSize
                let _ = self.imageCompression(image: compressedImage!)
                
            }else{
                return (image, false)
            }
            
        }else{
            return (image,true)
        }
        
        return (image,false)
        
    }
}


