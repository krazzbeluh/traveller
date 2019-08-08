//
//  Weather.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol sendWeatherStationDatasDelegate: class {
    func displayWeather(in city: City.CityName)
    func sendAlert(with type: NetworkService.NetworkError)
}

// MARK: - Weather
struct WeatherData: Decodable {
    let list: [List]
}

// MARK: - List
struct List: Decodable {
    let weather: [Weather]
    let main: Main
}

// MARK: - Main
struct Main: Decodable {
    let temp: Float
}

// MARK: - Weather
struct Weather: Decodable {
    let weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

class WeatherStation {
    weak var delegate: sendWeatherStationDatasDelegate?
    
    public let paris = City(name: .paris)
    public let newYork = City(name: .newYork)
    public var iconResponses = 0 {
        didSet {
            if self.iconResponses > 2 {
                self.iconResponses = 0
            }
        }
    }
    
    private let weatherRequest = NetworkService(url: "http://api.openweathermap.org/data/2.5/group?id=5128581,2988507&lang=fr&units=metric&appid=cc7f297c71ae7bee297e310c4e0c96cc") //swiftlint:disable:this line_length
    
    public func refreshWeather() {
        weatherRequest.getData { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                guard let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                    print("Unable to decode data")
                    return
                }
                
                self.newYork.temperature = weatherData.list[0].main.temp
                self.newYork.weather = weatherData.list[0].weather[0].weatherDescription
                let newYorkIconRequest = NetworkService(url:
                    "http://openweathermap.org/img/wn/\(weatherData.list[0].weather[0].icon)@2x.png")
                newYorkIconRequest.getData { result in
                    switch result {
                    case .success(let data):
                        self.newYork.weatherIcon = data
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                    self.iconResponses += 1
                    self.delegate?.displayWeather(in: .newYork)
                }
                
                self.paris.temperature = weatherData.list[1].main.temp
                self.paris.weather = weatherData.list[1].weather[0].weatherDescription
                let parisIconRequest = NetworkService(url:
                    "http://openweathermap.org/img/wn/\(weatherData.list[1].weather[0].icon)@2x.png")
                parisIconRequest.getData { result in
                    switch result {
                    case .success(let data):
                        self.paris.weatherIcon = data
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                    self.iconResponses += 1
                    self.delegate?.displayWeather(in: .paris)
                }
            }
        }
    }
}
