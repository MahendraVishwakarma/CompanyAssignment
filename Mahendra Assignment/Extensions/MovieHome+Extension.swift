//
//  MovieHome+Extension.swift
//  Mahendra Assignment
//
//  Created by Mahendra Vishwakarma on 03/08/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

extension MoviesHome:MovieViewModelProtocolDelegates{
    
    func serverResponse<T>(result: Result<T?, APIError>) where T : Decodable {
        
        DispatchQueue.main.async {
            switch result{
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
            case .success(let list):
                self.updateData(list: list)
            }
            
        }
    }
    
    func updateData<T:Decodable>(list:T){
        
        if(viewModel!.isPopularMOview){
            
            if((list as! MovieList).page >  moviePopular.page){
                movieList.removeAll()
                moviePopular.resultData.append(contentsOf: (list as! MovieList).results)
                movieList.append(contentsOf: moviePopular.resultData)
            }
            
            moviePopular.page = (list as! MovieList).page
        }else{
            
            if((list as! MovieNowPlaying).page >  moviewNowPlaying.page){
                movieList.removeAll()
                moviewNowPlaying.resultData.append(contentsOf: (list as! MovieNowPlaying).results)
                movieList.append(contentsOf: moviewNowPlaying.resultData)
            }
           
            moviewNowPlaying.page = (list as! MovieNowPlaying).page
        }
        movieListTableView.reloadData()
    }
    
}

extension MoviesHome:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        
        cell.setData(info: movieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviewDetails = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetails
        moviewDetails.movieID = movieList[indexPath.row].id
        self.navigationController?.pushViewController(moviewDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == movieList.count - 1 ) { //it's your last cell
            //Load more data & reload your tableview view
            sendRequestToserver()
        }
    }
    
    func sendRequestToserver(){
        
        do{
            
            if(selectedFilter == SelecterFilter.popular.localised){
                try viewModel?.fetchData(requestURL: .Popular, pageNumber: moviePopular.page+SelecterFilter.nowPlaying.localised)
            }else{
                try viewModel?.fetchData(requestURL: .NowPlaying, pageNumber: moviewNowPlaying.page+SelecterFilter.nowPlaying.localised)
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
}
