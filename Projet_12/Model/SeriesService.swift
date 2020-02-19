//
//  SeriesService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class SeriesService {
    private static let seriesListURL = "https://api.themoviedb.org/3/discover/tv"
    private static let serieImageURL = "https://image.tmdb.org/t/p/w500"
    
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    
    // An initializer which is used for the unit test
    init(session: URLSession) {
        self.session = session
    }
    
    // Function which creates an Url with parameters
    private func seriesListUrl(genre: Int) -> URL? {
        let stringGenre = String(genre)
        var seriesURL = URLComponents(string: SeriesService.seriesListURL)
        seriesURL?.queryItems = [URLQueryItem(name: "api_key", value: APIKeys.serieAPIKey),
                                 URLQueryItem(name: "with_genres", value: stringGenre)]
        
        guard let url = seriesURL?.url else { return nil }
        return url
    }
    
    // Function which gets an objet SeriesList from a response request
    func getSeriesList(genre: Int, callback: @escaping (Bool, SeriesList?) -> Void) {
        guard let url = seriesListUrl(genre: genre) else {
            callback(false, nil)
            return
        }
        
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                guard let seriesListJSON = try? JSONDecoder().decode(SeriesList.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                callback(true, seriesListJSON)
            }
        }
        task?.resume()
    }
    
    func getSerieImage(imageUrl: String, completionHandler: @escaping (Data?) -> Void) {
        guard let url = URL(string: SeriesService.serieImageURL + imageUrl) else {
            completionHandler(nil)
            return
        }
        
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                completionHandler(data)
            }
        }
        task?.resume()
    }
}
