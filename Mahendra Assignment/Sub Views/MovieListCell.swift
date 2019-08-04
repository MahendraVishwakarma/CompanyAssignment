//
//  MovieListCell.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 04/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var totalRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(info : ResultData){
        movieName.text = info.title
        totalRating.text = "\(info.voteAverage)"
        
        let image_fullURL = URLs.baseURL_image + info.posterPath
        let posterURL = URL.init(string: image_fullURL)
        posterImageView.kf.setImage(with: posterURL, placeholder: nil)
    }
    
}
