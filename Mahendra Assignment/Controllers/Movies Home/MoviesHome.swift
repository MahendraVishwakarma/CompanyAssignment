//
//  MoviesHome.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 03/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class MoviesHome: UIViewController {
    
    var viewModel : MovieViewModel?
    @IBOutlet weak var movieListTableView: UITableView!
    var movieList : Array<ResultData>!
    var moviePopular : MoviewData!
    var moviewNowPlaying : MoviewData!
    var selectedFilter:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieList = Array<ResultData>()
        moviePopular = MoviewData()
        moviewNowPlaying = MoviewData()
        
        viewModel = MovieViewModel()
        viewModel?.delegate = self
        do{
            try viewModel?.fetchData(requestURL: .Popular, pageNumber: moviePopular.page+SelecterFilter.nowPlaying.localised)
            
        }catch let error{
            print(error.localizedDescription)
        }
        
        self.movieListTableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        
    }
    
    @IBAction func movieFilter(_ sender: UISegmentedControl) {
        
        selectedFilter = sender.selectedSegmentIndex
        sendRequestToserver()
    }
    
    deinit {
        viewModel?.delegate = nil
        viewModel  = nil
        movieList = nil
        moviePopular = nil
        moviewNowPlaying = nil
    }
    
}

