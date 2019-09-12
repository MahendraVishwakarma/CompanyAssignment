//
//  navigationVC.swift
//  Badlee
//
//  Created by Mahendra on 27/06/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class navigationVC: NSObject,CLLocationManagerDelegate
{
     var lat:Double? = 0.0
     var long :Double? = 0.0
    static var sharedInstance = navigationVC()
    private override init() { }

}
