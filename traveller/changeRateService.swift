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
    enum ChangeRateDataTaskError: Error {
        case unableToDecodeData, APINoSuccess, noChangeRateInData
    }
    
    private let changeRateRequest = NetworkService(url:
        "http://data.fixer.io/api/latest?access_key=12db1bc4d9a970af827f07b4c5ad8b03&format=1&base=EUR&symbols=USD")
    
    public func getChangeRate(callback: @escaping(Result<Float, Error>) -> Void) {
        changeRateRequest.getData { result in
            switch result {
            case .success(let data):
                guard let rates = try? JSONDecoder().decode(RateDecoder.self, from: data) else {
                    callback(.failure(ChangeRateDataTaskError.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                guard rates.success else {
                    callback(.failure(ChangeRateDataTaskError.APINoSuccess))
                    return
                }
                
                guard let changeRate = rates.rates["USD"] else {
                    callback(.failure(ChangeRateDataTaskError.noChangeRateInData))
                    return
                }
                
                callback(.success(changeRate))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
