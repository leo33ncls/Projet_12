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
    private static let discoverSeriesURL = "https://api.themoviedb.org/3/discover/tv"

    // The main URL of the API that searches and sends series
    private static let searchSeriesURL = "https://api.themoviedb.org/3/search/tv"

    // The main URL of the API that finds and sends the serie
    private static let serieURL = "https://api.themoviedb.org/3/tv/"

    // The main URL of the API that sends the serie image
    private static let serieImageURL = "https://image.tmdb.org/t/p/w500"

    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    // An initializer which is used for the unit test
    init(session: URLSession) {
        self.session = session
    }

    /**
     Function which creates an Url with serie genres for the serie API.
     Calling this function adds the api key and a given genre to the discoverSeriesURL.

     - Parameter genre: The genre of the series we want the API to return.
     - Returns: A valid url for the serie API or a nil.
     */
    private func discoverSeriesUrl(genre: Int) -> URL? {
        let stringGenre = String(genre)
        var seriesURL = URLComponents(string: SeriesService.discoverSeriesURL)
        seriesURL?.queryItems = [URLQueryItem(name: "api_key",
                                              value: APIKeysService
                                                .valueForAPIKey(named: APIKeysService.serieAPIKey,
                                                                fileName: APIKeysService.fileName,
                                                                bundleClass: SeriesService.self)),
                                 URLQueryItem(name: "with_genres", value: stringGenre),
                                 URLQueryItem(name: "sort_by", value: "popularity.desc")]

        guard let url = seriesURL?.url else { return nil }
        return url
    }

    /**
     Function which creates an Url with paramaters to find a serie with the serie API.
     Calling this function completes the url path with a serie id, adds the api key to the parameters
     And then returns a valid url for the serie API.
     
     - Parameter serieId: The id of the serie we want informations.
     - Returns: A valid url to find a serie for the serie API or a nil.
     */
    private func findSerieUrl(serieId: Int) -> URL? {
        var serieURL = URLComponents(string: SeriesService.serieURL + String(serieId))
        serieURL?.queryItems = [URLQueryItem(name: "api_key",
                                             value: APIKeysService
                                                .valueForAPIKey(named: APIKeysService.serieAPIKey,
                                                                fileName: APIKeysService.fileName,
                                                                bundleClass: SeriesService.self))]
        guard let url = serieURL?.url else { return nil }
        return url
    }

    /**
     Function which creates an Url with paramaters to search series with the serie API.
     Calling this function adds the api key to the parameters, completes the url path with a string search
     And then returns a valid url for the serie API.
     
     - Parameter text: The title or a part of the serie title that the user searches.
     - Returns: A valid url to search series for the serie API or a nil.
     */
    private func searchSeriesUrl(text: String) -> URL? {
        var searchSerieURL = URLComponents(string: SeriesService.searchSeriesURL)
        searchSerieURL?.queryItems = [URLQueryItem(name: "api_key",
                                                   value: APIKeysService
                                                    .valueForAPIKey(named: APIKeysService.serieAPIKey,
                                                                    fileName: APIKeysService.fileName,
                                                                    bundleClass: SeriesService.self)),
                                      URLQueryItem(name: "query", value: text)]
        guard let url = searchSerieURL?.url else { return nil }
        return url
    }

    /**
     Function which returns a callback with a series list of a given genre.

     Calling this function calls the discoverSeriesUrl function,
     checks if the url is valid, sends a request with the url,
     gets a JSON responses from the API, tries to decode the response in a SeriesList
     and returns a callback with a series list.

     - Parameters:
        - genre: The genre of the series we want the API to return.
        - callback: The callback returning the series list.
     */
    func getSeriesList(genre: Int, callback: @escaping (Bool, SeriesList?) -> Void) {
        guard let url = discoverSeriesUrl(genre: genre) else {
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
     Function which returns a callback with some informations of a given serie.
     
     Calling this function calls the findSerieUrl function,
     checks if the url is valid, sends a request with the url,
     gets a JSON responses from the API, tries to decode the response in a Result
     and returns a callback with a serie.
     
     - Parameters:
     - serieId: The id of the serie we want informations.
     - callback: The callback returning the series list.
     */
    func getSerie(serieId: Int, callback: @escaping (Bool, Result?) -> Void) {
        guard let url = findSerieUrl(serieId: serieId) else {
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

                guard let serieJSON = try? JSONDecoder().decode(Result.self, from: data) else {
                    callback(false, nil)
                    return
                }

                callback(true, serieJSON)
            }
        }
        task?.resume()
    }

    /**
     Function which returns a callback with a series list of a user search.
     
     Calling this function calls the searchSeriesUrl function,
     checks if the url is valid, sends a request with the url,
     gets a JSON responses from the API, tries to decode the response in a SeriesList
     and returns a callback with a series list.
     
     - Parameters:
     - searchText: The title or a part of the serie title that the user searches.
     - callback: The callback returning the series list.
     */
    func searchSeries(searchText: String, callback: @escaping (Bool, SeriesList?) -> Void) {
        guard let url = searchSeriesUrl(text: searchText) else {
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
