//
//  FakeRateData.swift
//  travellerTests
//
//  Created by Paul Leclerc on 06/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class FakeResponseData {
    class RateError: Error {}
    static let error = RateError()
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    static func correctData(ressourceName: String) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: ressourceName, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}
