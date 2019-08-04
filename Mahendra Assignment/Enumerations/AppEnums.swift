import Foundation

// generics type
public enum Result<T, U> where U:Error{
    case success(T)
    case failure(U)
}

// custom error
public enum APIError:Error{
    
    case failedRequest(String?)
}

// hTTPS methods type
public enum HttpsMethod{
    case Post
    case Get
    case Put
    
    var localization:String{
        switch self {
        case .Post: return "POST"
        case .Get: return "GET"
        case .Put: return "PUT"
            
        }
        
    }
}

public enum MovieFilter{
    case NowPlaying
    case Popular
    
    var localised:String{
        switch self{
        case .NowPlaying: return HttpURL.MoviewNowPlaying.localised
        case .Popular: return HttpURL.MoviePopular.localised
        }
    }
}


public enum HttpURL{
    case MoviePopular
    case MoviewNowPlaying
    case MovieDetails
    
    var localised:String{
        switch self {
        case .MoviePopular: return String(format: URLs.movieURLPopular, Constants.api_key)
        case .MoviewNowPlaying: return String(format: URLs.moviewURLNowPLaying, Constants.api_key)
        case .MovieDetails: return URLs.movieDetails
            
        }
    }
}

public enum SelecterFilter{
    case popular
    case nowPlaying
    
    var localised : Int{
        switch self{
        case .popular: return 0
        case .nowPlaying: return 1
        }
        
    }
}
