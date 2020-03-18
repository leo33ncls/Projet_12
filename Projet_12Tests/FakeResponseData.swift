//
//  FakeResponseData.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//
// swiftlint:disable force_try

import Foundation

class FakeResponseData {
    static var SeriesListCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SeriesList", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }

    static let incorrectData = "erreur".data(using: .utf8)!

    static let responseOK = HTTPURLResponse(url: URL(string: "https://")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)

    static let responseKO = HTTPURLResponse(url: URL(string: "https://")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)

    class ResquestError: Error {}
    static let error = ResquestError()
}
