//
//  MovieDetals+Extension.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
extension MovieDetails:MovieViewModelProtocolDelegates{
    
    func serverResponse<T>(result: Result<T?, APIError>) where T : Decodable {
        
        DispatchQueue.main.async {
            switch result{
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
            case .success(let info):
                self.updateData(info: info as! MovieDetailsModel)
            }
            
        }
    }
    
    func updateData(info:MovieDetailsModel){
        let image_fullURL = URLs.baseURL_image + (info.posterPath ?? "")
        let posterURL = URL.init(string: image_fullURL)
        posterImageView.kf.setImage(with: posterURL, placeholder: nil)
        movieName.text = info.title
        ratingSCore.text = "⭐ \(info.voteAverage ?? 0)"
        votes.text = "Total vote:\(info.voteCount ?? 0)"
        releasingDate.text = "Releasing Date:\(info.releaseDate )"
        runningTime.text = "Running Time:\(info.runtime ?? 0)"
        originalLan.text = "Original Lang:\(info.originalLanguage ?? "")"
        synopsys.text = info.overview
        generics.text = viewModel?.setupGenerics(generics: info.genres)
    }
    
}
