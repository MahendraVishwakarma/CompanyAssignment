//
//  Enums.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 05/06/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation

//Generics for response data
public enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

public enum APIError: Error {
    
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case noInternetConnection
    
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:                    return ""
        case .invalidData:                      return "Invalid Data"
        case .responseUnsuccessful:             return "Response Unsuccessful"
        case .jsonParsingFailure:               return "JSON Parsing Failure"
        case .jsonConversionFailure:            return "JSON Conversion Failure"
        case .noInternetConnection:             return "Please check internet connection"
        case let .serverError(message):
            return message
        
        }
    }
}
