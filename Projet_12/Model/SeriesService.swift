//
//  SeriesService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// Class that manages the series and the series API
class SeriesService {
    
    // The main URL of the API that sends the series list
    private static let seriesListURL = "https://api.themoviedb.org/3/discover/tv"
    
    // The main URL of the API that sends the serie image
    private static let serieImageURL = "https://image.tmdb.org/t/p/w500"
    
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    
    // An initializer which is used for the unit test
    init(session: URLSession) {
        self.session = session
    }
    
    /**
     Function which creates an Url with paramaters for the serieList API.
     Calling this function adds the api key and a given genre to the serieListURL.
     
     - Parameter genre: The genre of the series we want the API to return.
     - Returns: A valid url for the seriesList API or a nil.
     */
    private func seriesListUrl(genre: Int) -> URL? {
        let stringGenre = String(genre)
        var seriesURL = URLComponents(string: SeriesService.seriesListURL)
        seriesURL?.queryItems = [URLQueryItem(name: "api_key", value: APIKeys.serieAPIKey),
                                 URLQueryItem(name: "with_genres", value: stringGenre)]
        
        guard let url = seriesURL?.url else { return nil }
        return url
    }
    
    /**
     Function which returns a callback with a series list of a given genre.
     
     Calling this function calls the seriesListUrl function,
     checks if the url is valid, sends a request with the url,
     gets a JSON responses from the API, tries to decode the response in a SeriesList
     and returns a callback with a series list.
     
     - Parameters:
        - genre: The genre of the series we want the API to return.
        - callback: The callback returning the series list.
     */
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
    
    /**
     Function which returns a completionHandler with an image data.

     Calling this function creates an url with a given image url,
     checks if the url is valid, sends a request with the url,
     gets data from the API and returns a completionHandler with image data.
     
     - Parameters:
        - imageUrl: A string of the image url we want the data.
        - completionHandler: A completionHandler returning the image data.
     */
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
