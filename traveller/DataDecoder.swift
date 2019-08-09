//
//  DataDecoder.swift
//  traveller
//
//  Created by Paul Leclerc on 09/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class DataDecoder {}

//
//  Decoder for Converter
//

extension DataDecoder {
    public struct RateDecoder: Decodable {
        let rates: [String: Float]
        let success: Bool
    }
}

//
//  Decoder for translator
//

extension DataDecoder {
    public struct GTranslateDecoder: Codable {
        let data: DataClass
    }
    
    public struct DataClass: Codable {
        let translations: [Translation]
    }
    
    public struct Translation: Codable {
        let translatedText: String
    }
}

//
//  Decoder for Weather
//

extension DataDecoder {
    public struct WeatherData: Decodable {
        let list: [List]
    }
    
    public struct List: Decodable {
        let weather: [Weather]
        let main: Main
    }
    
    public struct Main: Decodable {
        let temp: Float
    }
    
    public struct Weather: Decodable {
        let weatherDescription, icon: String
        
        enum CodingKeys: String, CodingKey {
            case weatherDescription = "description"
            case icon
        }
    }
}
