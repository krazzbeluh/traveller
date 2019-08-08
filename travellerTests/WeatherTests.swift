//
//  WeatherTests.swift
//  travellerTests
//
//  Created by Paul Leclerc on 07/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import traveller

class WeatherTests: XCTestCase {
    var weatherStation: WeatherStation!
    
    override func setUp() {
        weatherStation = WeatherStation()
    }
}
