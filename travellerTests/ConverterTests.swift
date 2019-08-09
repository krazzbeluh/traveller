//
//  ConverterTests.swift
//  travellerTests
//
//  Created by Paul Leclerc on 07/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import traveller

class ConverterTests: XCTestCase {

    var converter: Converter!
    
    override func setUp() {
        converter = Converter()
        converter.changeRate = 2
    }
    
    func testGivenChangeRateIs2_WhenConverting4_ThenResultIs8() {
        
        do {
            try converter.convert("4")
        } catch {
            XCTAssert(false)
        }
        
        XCTAssertEqual(converter.moneyInDollar, 8)
    }
    
    func testGivenConvertReturnsErrorIfNumberIsNotANumber() {
        var isError = false
        
        do {
            try converter.convert("X")
        } catch let error as Converter.ConvertError {
            XCTAssertEqual(error, Converter.ConvertError.notANumber)
            isError = true
        } catch {
            XCTAssert(false)
        }
        
        XCTAssertTrue(isError)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfError() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.error = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfnoData() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.noData = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfIncorrectResponse() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case NetworkService.NetworkError.responseNot200 = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnSuccessCallbackIfNoError() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Rate"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success:
                XCTAssert(self.converter.changeRate == 1.118287)
            case .failure(_):
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfUnableToDecode() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Translation"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case Converter.ConvertError.unableToDecodeData = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfApiDoesntReturnSuccess() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "RateNotSuccess"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case Converter.ConvertError.APINoSuccess = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetChangeRateShouldReturnFailedCallbackIfNoChangeRateInData() {
        converter.changeRateRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "RateWithoutUSD"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case Converter.ConvertError.noChangeRateInData = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
