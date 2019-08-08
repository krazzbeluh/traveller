//
//  NetworkServiceTests.swift
//  travellerTests
//
//  Created by Paul Leclerc on 06/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import traveller

class NetworkServiceTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetDataShouldPostFailedCallbackIfError() {
        let rateService = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        rateService.getData { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error == .error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDataShouldPostFailedCallbackIfnoData() {
        let rateService = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        rateService.getData { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error == .noData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDataShouldPostFailedCallbackIfIncorrectResponse() {
        let rateService = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Rate"),
                           response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        rateService.getData { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error == .responseNot200)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDataShouldPostSuccessCallbackIfNoError() {
        let rateService = NetworkService(networkSession: URLSessionFake(data:
            FakeResponseData.correctData(ressourceName: "Rate"), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        rateService.getData { result in
            switch result {
            case .success(let data):
                print(data)
                XCTAssertNotNil(data)
            case .failure(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
