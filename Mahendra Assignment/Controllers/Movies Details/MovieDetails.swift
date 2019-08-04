
//
//  MovieDetails.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 03/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class MovieDetails: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var ratingSCore: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var releasingDate: UILabel!
    @IBOutlet weak var runningTime: UILabel!
    @IBOutlet weak var originalLan: UILabel!
    @IBOutlet weak var generics: UILabel!
    @IBOutlet weak var synopsys: UILabel!
    var movieID:Int!
    var viewModel : MovieDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieDetailsViewModel()
        viewModel?.delegate = self
        viewModel?.fetchData(requestURL: .MovieDetails, movieID: movieID)
    }
    
    
    
}
