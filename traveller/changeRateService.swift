//
//  File.swift
//  Traveller
//
//  Created by Paul Leclerc on 25/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

fileprivate struct RateDecoder: Decodable {
    let rates: [String: Float]
    let success: Bool
}

class ChangeRateService {
    static var shared = ChangeRateService()
    private init() {}
    
    private static let changeRateUrl = URL(string:
        "http://data.fixer.io/api/latest?access_key=12db1bc4d9a970af827f07b4c5ad8b03&format=1&base=EUR&symbols=USD")!
    private var task: URLSessionDataTask?
    private var changeRateSession = URLSession(configuration: .default)
    
    init(changeRateSession: URLSession) {
        self.changeRateSession = changeRateSession
    }
    
    enum ChangeRateDataTaskError: Error {
        case noData, error, responseNot200, unableToDecodeData, APINoSuccess, noChangeRateInData
    }
    
    func getChangeRate(callback: @escaping (Result<Float, ChangeRateDataTaskError>) -> Void) {
        var request = URLRequest(url: ChangeRateService.changeRateUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = changeRateSession.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data else {
                    callback(.failure(.noData))
                    return
                }
                
                guard error == nil else {
                    callback(.failure(.error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.responseNot200))
                    return
                }
                
                guard let rates = try? JSONDecoder().decode(RateDecoder.self, from: data) else {
                    callback(.failure(.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                guard rates.success else {
                    callback(.failure(.APINoSuccess))
                    return
                }
                
                guard let changeRate = rates.rates["USD"] else {
                    callback(.failure(.noChangeRateInData))
                    return
                }
                
                callback(.success(changeRate))
            }
        }
        task?.resume()
    }
}
