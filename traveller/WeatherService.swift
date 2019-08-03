//
//  File.swift
//  Traveller
//
//  Created by Paul Leclerc on 25/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

fileprivate struct WeatherDecoder: Decodable {
    let weather: [Weather]
    let main: Main
}

fileprivate struct Main: Decodable {
    let temp: Float
    let tempMin, tempMax: Float
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

fileprivate struct Weather: Decodable {
    let weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    private static let newYorkWeatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=New%20York&appid=cc7f297c71ae7bee297e310c4e0c96cc&lang=fr&units=metric")!
    private static let parisWeatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Paris&appid=cc7f297c71ae7bee297e310c4e0c96cc&lang=fr&units=metric")!
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    enum WeatherDataTaskError: Error {
        case noData, error, responseNot200, unableToDecodeData, APINoSuccess
    }
    
    func getWeather(at local: City.CityName, callback: @escaping (Result<City, WeatherDataTaskError>) -> Void) {
        var request: URLRequest
        switch local {
        case .paris:
            request = URLRequest(url: WeatherService.parisWeatherUrl)
        case .newYork:
            request = URLRequest(url: WeatherService.newYorkWeatherUrl)
        }
        
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) -> Void in
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
                
                guard let weatherInfos = try? JSONDecoder().decode(WeatherDecoder.self, from: data) else {
                    callback(.failure(.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                let city = City(name: local)
                city.temperature = weatherInfos.main.temp
                city.weather = weatherInfos.weather[0].weatherDescription
                
                callback(.success(city))
            }
        }
        task?.resume()
    }
}
