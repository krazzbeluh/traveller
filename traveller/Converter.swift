//
//  Converter.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

// refreshing resets convertion

protocol sendConverterDatasDelegate: class {
    func displayDollar()
    func displayChangeRate()
    func sendAlert(with type: Error)
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
    
    public enum ConvertError: Error {
        case notANumber
    }
    
    public func convert(_ numberText: String?) throws {
        guard let value = Float(numberText!) else {
            throw ConvertError.notANumber
        }
        
        moneyInDollar = value * changeRate
    }
    
    public func getChangeRateValue(callback: @escaping (() -> Void)) {
        ChangeRateService().getChangeRate { result in
            
            switch result {
            case .success(let changeRate):
                print("changerate is \(changeRate) today")
                self.displayChangeRate(value: changeRate)
            case .failure(let error):
                self.delegate?.sendAlert(with: error)
            }
            callback()
        }
    }
    
    private func displayChangeRate(value changeRate: Float) {
        self.changeRate = changeRate
        changeRateDay = Date()
        
        do {
            try convert("1")
        } catch let error as ConvertError {
            print(error)
        } catch {
            fatalError("Oops ! Something went wrong !")
        }
        
        delegate?.displayChangeRate()
    }
}
