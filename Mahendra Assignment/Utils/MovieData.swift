//
//  MovieData.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

class MoviewData:NSObject{
    
    override init() {
    resultData = Array<ResultData>()
        
    }
    
    var resultData:[ResultData]!
    var page:Int = 0
    
}
