//
//  MovieViewModel.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 03/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

public class MovieViewModel:MovieViewModelProtocol{
    
    public weak var delegate: MovieViewModelProtocolDelegates?
    var isPopularMOview : Bool = true
    
    
    init() {
        
    }
    
    public func fetchData(requestURL: MovieFilter,pageNumber:Int)  throws -> Void {
        
        if(pageNumber <= 0 || self.delegate == nil){
            
            throw APIError.failedRequest("Invalid input")
            
        }
        startLoader()
        let urlWithPage = requestURL.localised + "\(pageNumber)"
        if(requestURL == .NowPlaying){
            isPopularMOview = false
            fetchNowPlaying(pageNumber: pageNumber, urlWithPage: urlWithPage)
        }else{
            isPopularMOview = true
            fetchPopularMoview(pageNumber: pageNumber, urlWithPage: urlWithPage)
        }
        
    }
    
    func fetchPopularMoview(pageNumber:Int,urlWithPage:String){
        WebServices.requestHttp(urlString: urlWithPage, method: .Get, decode: { json -> MovieList? in
            guard let response = json as? MovieList else{
                return nil
            }
            
            return response
        }) {[weak self]  (result) in
            
            self?.delegate?.serverResponse(result: result)
            self?.stopLoader()
        }
    }
    
    func fetchNowPlaying(pageNumber:Int,urlWithPage:String){
        WebServices.requestHttp(urlString: urlWithPage, method: .Get, decode: { json -> MovieNowPlaying? in
            guard let response = json as? MovieNowPlaying else{
                return nil
            }
            
            return response
        }) {[weak self]  (result) in
            
            self?.delegate?.serverResponse(result: result)
            self?.stopLoader()
        }
    }
    
    private func startLoader(){
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
        let loader = ActivityLoader(frame: rect)
        loader.tag = 100
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(loader)
    }
    
    private func stopLoader(){
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).window?.viewWithTag(100)?.removeFromSuperview()
        }
        
    }
    
    deinit {
        delegate = nil
    }
    
}
