//
//  File.swift
//  Traveller
//
//  Created by Paul Leclerc on 25/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class WeatherIconService {
    static var shared = WeatherIconService()
    private init() {}
    
    private static let newYorkWeatherIconUrl = URL(string: "http://openweathermap.org/img/wn/11n@2x.png")!
    private static let parisWeatherIconUrl = URL(string: "http://openweathermap.org/img/wn/02d@2x.png")!
    private var task: URLSessionDataTask?
    private var weatherIconSession = URLSession(configuration: .default)
    
    init(weatherIconSession: URLSession) {
        self.weatherIconSession = weatherIconSession
    }
    
    enum WeatherIconDataTaskError: Error {
        case noData, error, responseNot200
    }
    
    func getWeatherIcon(at local: City.CityName, callback: @escaping (Result<Data, WeatherIconDataTaskError>) -> Void) {
        var request: URLRequest
        switch local {
        case .paris:
            request = URLRequest(url: WeatherIconService.parisWeatherIconUrl)
        case .newYork:
            request = URLRequest(url: WeatherIconService.newYorkWeatherIconUrl)
        }
        
        request.httpMethod = "GET"
        
        task?.cancel()
        task = weatherIconSession.dataTask(with: request) { (data, response, error) -> Void in
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
                
                callback(.success(data))
            }
        }
        task?.resume()
    }
}
