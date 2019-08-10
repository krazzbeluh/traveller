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
    
    func testTemperatureConvertion() {
        weatherStation.paris.temperature = 2
        
        XCTAssertEqual(weatherStation.paris.temperatureF, 35.6)
    }
    
    func testRefreshWeatherShouldReturnFailedCallbackIfError() {
        weatherStation.weatherRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.error = error {
                    expectation.fulfill()
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testRefreshWeatherShouldReturnFailedCallbackIfNoData() {
        weatherStation.weatherRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.noData = error {
                    expectation.fulfill()
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testRefreshWeatherShouldReturnFailedCallbackIfBadResponse() {
        weatherStation.weatherRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.responseNot200 = error {
                    expectation.fulfill()
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testRefreshWeatherShouldReturnFailedCallbackIfUnableToDecodeData() {
        weatherStation.weatherRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Translation"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case WeatherStation.WeatherDataTaskError.unableToDecodeData = error {
                    expectation.fulfill()
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testRefreshWeatherShouldReturnSuccessCallbackIfNoError() {
        weatherStation.weatherRequest = NetworkService(networkSession: URLSessionFake(data:
            FakeResponseData.correctData(ressourceName: "Weather"), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                XCTAssertEqual(self.weatherStation.newYork.temperature, 19.79)
                XCTAssertEqual(self.weatherStation.newYork.weather, "ciel dégagé")
                XCTAssertEqual(self.weatherStation.newYork.weatherIconCode, "01d")
                XCTAssertEqual(self.weatherStation.paris.temperature, 24.27)
                XCTAssertEqual(self.weatherStation.paris.weather, "couvert")
                XCTAssertEqual(self.weatherStation.paris.weatherIconCode, "04d")
                expectation.fulfill()
            case .failure:
                XCTAssert(false)
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
