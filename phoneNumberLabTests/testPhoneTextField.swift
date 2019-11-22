//
//  testPhoneTextField.swift
//  phoneNumberLabTests
//
//  Created by Tom Stamm on 11/21/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import XCTest
@testable import phoneNumberLab

class testPhoneTextField: XCTestCase {
    let phonenumberText = PhoneTextField( frame:CGRect( x:10, y:10, width:10, height:10) )
    let currentErrorCode:PhoneNumberErrors = .noError

    override func setUp() {
        phonenumberText.errorDelegate = self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension testPhoneTextField: PhoneTextFieldProtocol {
        func phoneNumberTextGeneratedError( _ error:PhoneNumberErrors ) {
            
            switch error {
            case .noError:
                   print("No Error")
                
            case .overflowError:
                print("data too big for phone number: expected length <= 10")
            
            case .illegalCharacterError:
                print("Non-legal characters would be added for phone number: expected characters '0123456789( -)'")
        }
    }
}
