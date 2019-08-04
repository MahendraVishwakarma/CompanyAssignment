//
//  MovieDetailsModelView.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

public class MovieDetailsViewModel:MovieDetalsViewModelProtocol{
    
    public weak var delegate: MovieViewModelProtocolDelegates?
    
    init() {
        
    }
    
    public func fetchData(requestURL: HttpURL,movieID:Int) {
        
        startLoader()
        let urlWithPage = String(format: requestURL.localised,movieID, Constants.api_key)
        WebServices.requestHttp(urlString: urlWithPage, method: .Get, decode: { json -> MovieDetailsModel? in
            guard let response = json as? MovieDetailsModel else{
                return nil
            }
            
            return response
        }) {[weak self]  (result) in
            
            self?.delegate?.serverResponse(result: result)
            self?.stopLoader()
        }
    }
    
    func setupGenerics(generics:Array<Genre>) ->String{
        var strGenerics = ""
        for item in generics{
            strGenerics = strGenerics + item.name + " ● "
        }
        strGenerics = String(String(strGenerics.dropLast()).dropLast())
        return strGenerics
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
