//
//  City.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class City {
    public enum CityName {
        case paris, newYork
    }
    
    let name: CityName
    var temperature: Float = 0.0
    var temperatureF: Float {
        return 9 / 5 * temperature + 32
    }
    var weather: String?
    var weatherIconCode: String?
    var weatherIcon: Data?
    
    init(name: CityName) {
        self.name = name
    }
}
