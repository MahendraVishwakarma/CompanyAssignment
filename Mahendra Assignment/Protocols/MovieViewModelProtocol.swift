//
//  MovieViewModelProtocol.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 03/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

public protocol MovieViewModelProtocol:class{
    var delegate : MovieViewModelProtocolDelegates?{get set}
    func fetchData(requestURL:MovieFilter,pageNumber:Int) throws -> Void
}

public protocol MovieDetalsViewModelProtocol:class{
    var delegate : MovieViewModelProtocolDelegates?{get set}
    func fetchData(requestURL:HttpURL,movieID:Int)
}

public protocol MovieViewModelProtocolDelegates:class{
    func serverResponse<T:Decodable>(result:Result<T?,APIError>)
}
