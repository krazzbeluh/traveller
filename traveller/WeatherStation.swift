//
//  Weather.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol sendWeatherStationDatasDelegate: SharedController {
    func displayWeather(in city: City.CityName)
}

class WeatherStation {
    weak var delegate: sendWeatherStationDatasDelegate?
    
    public enum WeatherDataTaskError: Error {
        case unableToDecodeData
    }
    
    public let paris = City(name: .paris)
    public let newYork = City(name: .newYork)
    
    public var weatherRequest = NetworkService(url: "http://api.openweathermap.org/data/2.5/group?id=5128581,2988507&lang=fr&units=metric&appid=cc7f297c71ae7bee297e310c4e0c96cc") //swiftlint:disable:this line_length
    public var weatherIconRequest: NetworkService?
    
    public func refreshWeather(callback: @escaping (Result<Void, Error>) -> Void) {
        weatherRequest.getData { result in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let data):
                guard let weatherData = try? JSONDecoder().decode(DataDecoder.WeatherData.self, from: data) else {
                    callback(.failure(WeatherDataTaskError.unableToDecodeData))
                    return
                }
                
                self.newYork.temperature = weatherData.list[0].main.temp
                self.newYork.weather = weatherData.list[0].weather[0].description
                self.newYork.weatherIconCode = weatherData.list[0].weather[0].icon
                self.paris.temperature = weatherData.list[1].main.temp
                self.paris.weather = weatherData.list[1].weather[0].description
                self.paris.weatherIconCode = weatherData.list[1].weather[0].icon
                
                callback(.success(()))
            }
        }
    }
    
    public func getWeatherIcon(for city: City, callback: @escaping (Result<Void, Error>) -> Void) {
        if city.weatherIconCode != "test" {
            weatherIconRequest = NetworkService(url:
                "http://openweathermap.org/img/wn/\(city.weatherIconCode!)@2x.png")
        }
        
        weatherIconRequest?.getData { result in
            switch result {
            case .success(let data):
                city.weatherIcon = data
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
