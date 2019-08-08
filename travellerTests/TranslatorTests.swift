//
//  TranslatorTests.swift
//  travellerTests
//
//  Created by Paul Leclerc on 07/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import traveller

class TranslatorTests: XCTestCase {
    var translator: Translator!
    
    override func setUp() {
        translator = Translator()
    }
    
    func testTranslatedTextIsHelloWhenCallingTranslateBonjour() {
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
            switch result {
            case .success(let translation):
                XCTAssertEqual(translation, "Bonjour")
            case .failure(let error):
                switch error {
                case NetworkService.NetworkError.error:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
                
//                XCTAssert(error == NetworkService.NetworkError.error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
