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
    
    func testGetTranslationShouldReturnFailedCallbackIfError() {
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
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
    
    func testGetTranslationShouldReturnFailedCallbackIfnoData() {
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
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
    
    func testGetTranslationShouldReturnFailedCallbackIfIncorrectResponse() {
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: nil, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
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
    
    func testGetTranslationShouldReturnSuccessCallbackIfNoError() {
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Translation"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
            switch result {
            case .success(let translation):
                XCTAssertEqual(translation, "Hello")
            case .failure(_): //swiftlint:disable:this empty_enum_arguments
                    XCTAssert(false)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldReturnFailedCallbackIfIncorrectData() {
        translator.textToTranslate = ""
        translator.translationRequest = NetworkService(networkSession:
            URLSessionFake(data: FakeResponseData.correctData(ressourceName: "Rate"),
                           response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change.")
        
        translator.translate { result in
            switch result {
            case .success(_): //swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(let error):
                if case Translator.TranslationDataTaskError.unableToDecodeData = error {
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
