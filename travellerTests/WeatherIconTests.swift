//
//  WeatherIconTests.swift
//  travellerTests
//
//  Created by Paul Leclerc on 09/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import traveller

class WeatherIconTests: XCTestCase {

    var weatherStation: WeatherStation!
    
    override func setUp() {
        weatherStation = WeatherStation()
        weatherStation.paris.weatherIconCode = "test"
    }

    func testGetWeatherIconShouldReturnFailedCallbackIfError() {
        weatherStation.weatherIconRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.getWeatherIcon(for: weatherStation.paris) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.error = error {
                    XCTAssert(true)
                    expectation.fulfill()
                } else {
                    XCTAssert(false)
                }
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherIconShouldReturnFailedCallbackIfNoData() {
        weatherStation.weatherIconRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.getWeatherIcon(for: weatherStation.paris) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.noData = error {
                    XCTAssert(true)
                    expectation.fulfill()
                } else {
                    XCTAssert(false)
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherIconShouldReturnFailedCallbackIfIncorrectResponse() {
        weatherStation.weatherIconRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.getWeatherIcon(for: weatherStation.paris) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.responseNot200 = error {
                    XCTAssert(true)
                    expectation.fulfill()
                } else {
                    XCTAssert(false)
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherIconShouldReturnSuccessCallbackIfNoError() {
//        I use Rate.json because i don't care about type of data returned by
//        getWeatherIcon because I just want to test if it returns Data
        weatherStation.weatherIconRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Rate"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        weatherStation.getWeatherIcon(for: weatherStation.paris) { result in
            switch result {
            case .success:
                XCTAssertNotNil(self.weatherStation.paris.weatherIcon)
                expectation.fulfill()
            case .failure:
                XCTAssert(false)
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
