//
//  MovieHome.swift
//  Mahendra AssignmentTests
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import XCTest
@testable import Mahendra_Assignment

class MovieHome: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
       
        }
    }
    
    func testObject() {
        let object = MovieViewModel()
        XCTAssertNotNil(object)
    }
    
    func testPropertyAccess() {
        // tested with invalid data. for success we have to pass right data like valid pagenumber 1,2,3,4 ...
        // we have tp pass delegate, if delegate is nil then it will throw error.
        let object = MovieViewModel()
        object.delegate = MovieHome().self as? MovieViewModelProtocolDelegates
        do{
           try object.fetchData(requestURL: .NowPlaying, pageNumber: -1)
        }catch let error{
            XCTFail(error.localizedDescription)
            
        }
        
    }
    func testPerformance(){
        let object = MovieViewModel()
        self.measure {
            do{
               try object.fetchData(requestURL: .NowPlaying, pageNumber: 1)
            }catch let error{
                XCTFail(error.localizedDescription)
            }
        }
    }

}
