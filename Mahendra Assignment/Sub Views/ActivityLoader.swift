//
//  ActivityLoader.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class ActivityLoader: UIView {
    
    let xibName = "ActivityLoader"
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialization()
    }
    
    func initialization() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        containerView.setFrameInView(self)
        
    }
    
    func stopLoader(){
        self.removeFromSuperview()
    }
    
    
}
