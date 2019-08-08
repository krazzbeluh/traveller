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

}
