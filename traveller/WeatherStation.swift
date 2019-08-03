//
//  Weather.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol sendWeatherStationDatasDelegate: class {
    func displayWeather(in city: City)
    func sendAlert(with type: WeatherService.WeatherDataTaskError)
}

class WeatherStation {
    weak var delegate: sendWeatherStationDatasDelegate?
    
    public let paris = City(name: .paris)
    public let newYork = City(name: .newYork)
    
    public func refreshWeather() {
        WeatherService.shared.getWeather(at: .newYork) { result in
            switch result {
            case .success(let city):
                self.newYork.temperature = city.temperature
                self.newYork.weather = city.weather
                self.delegate?.displayWeather(in: self.newYork)
                
                WeatherService.shared.getWeather(at: .paris) { result in
                    switch result {
                    case .success(let city):
                        self.paris.temperature = city.temperature
                        self.paris.weather = city.weather
                        self.delegate?.displayWeather(in: self.paris)
                    case .failure(let error):
                        self.delegate?.sendAlert(with: error)
                    }
                }
            case .failure(let error):
                self.delegate?.sendAlert(with: error)
            }
        }
    }
}
