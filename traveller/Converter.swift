//
//  Converter.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

// refreshing resets convertion

protocol sendConverterDatasDelegate: SharedController {
    func displayDollar()
    func displayChangeRate()
}

import Foundation

class Converter {
    weak var delegate: sendConverterDatasDelegate?
    public var changeRate: Float = 0.0
    public var changeRateDay = Date()
    
    public var moneyInDollar: Float? {
        didSet {
            delegate?.displayDollar()
        }
    }
    
    public var changeRateRequest = NetworkService(url:
        "http://data.fixer.io/api/latest?access_key=12db1bc4d9a970af827f07b4c5ad8b03&format=1&base=EUR&symbols=USD")
    
    public enum ConvertError: Error {
        case notANumber, unableToDecodeData, APINoSuccess, noChangeRateInData
    }
    
    public func convert(_ numberText: String?) throws {
        guard let value = Float(numberText!) else {
            throw ConvertError.notANumber
        }
        
        moneyInDollar = value * changeRate
    }
    
    public func getChangeRateValue(callback: @escaping (Result<Void, Error>) -> Void) {
        changeRateRequest.getData { result in
            switch result {
            case .success(let data):
                guard let rates = try? JSONDecoder().decode(DataDecoder.RateDecoder.self, from: data) else {
                    callback(.failure(ConvertError.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                guard rates.success else {
                    callback(.failure(ConvertError.APINoSuccess))
                    return
                }
                
                guard let changeRate = rates.rates["USD"] else {
                    callback(.failure(ConvertError.noChangeRateInData))
                    return
                }
                
                self.displayChangeRate(value: changeRate)
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    private func displayChangeRate(value changeRate: Float) {
        self.changeRate = changeRate
        changeRateDay = Date()
        
        do {
            try convert("1")
        } catch let error as ConvertError {
            delegate?.sendAlert(with: error)
        } catch {
            fatalError("Oops ! Something went wrong !")
        }
        
        delegate?.displayChangeRate()
    }
}
