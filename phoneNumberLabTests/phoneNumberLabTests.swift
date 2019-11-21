//
//  phoneNumberLabTests.swift
//  phoneNumberLabTests
//
//  Created by Tom Stamm on 11/18/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import XCTest
@testable import phoneNumberLab


class phoneNumberLabTests: XCTestCase {
    let first = FirstViewController()

    override func setUp() {
        first.resultLbl = UILabel()
        first.overflowMessageLbl = UILabel()
        first.positionSlider = UISlider()
        first.positionLbl = UILabel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLookup() {
        var result = first.lookup[0]
        XCTAssertEqual( result, 0, "Unexpect return from lookup")

        result = first.lookup[1]
        XCTAssertEqual( result, 0, "Unexpect return from lookup")

        result = first.lookup[2]
        XCTAssertEqual( result, 1, "Unexpect return from lookup")

        result = first.lookup[3]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = first.lookup[4]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = first.lookup[5]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = first.lookup[6]
        XCTAssertEqual( result, 3, "Unexpect return from lookup")

        result = first.lookup[7]
        XCTAssertEqual( result, 4, "Unexpect return from lookup")

        result = first.lookup[8]
        XCTAssertEqual( result, 5, "Unexpect return from lookup")

        result = first.lookup[9]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = first.lookup[10]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = first.lookup[11]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = first.lookup[12]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = first.lookup[13]
        XCTAssertEqual( result, 7, "Unexpect return from lookup")

        result = first.lookup[14]
        XCTAssertEqual( result, 8, "Unexpect return from lookup")

        result = first.lookup[15]
        XCTAssertEqual( result, 9, "Unexpect return from lookup")
    }
    

    
    func testReverseLookup() {
        var result = first.reverseLookup[0]
        XCTAssertEqual( result, 1, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[1]
        XCTAssertEqual( result, 2, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[2]
        XCTAssertEqual( result, 3, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[3]
        XCTAssertEqual( result, 6, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[4]
        XCTAssertEqual( result, 7, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[5]
        XCTAssertEqual( result, 8, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[6]
        XCTAssertEqual( result, 9, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[7]
        XCTAssertEqual( result, 13, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[8]
        XCTAssertEqual( result, 14, "Unexpect return from reverseLookup")
        
        result = first.reverseLookup[9]
        XCTAssertEqual( result, 15, "Unexpect return from reverseLookup")
    }
    
    func testSanitize() {
        var result = first.sanitize( "(987) 654 - 3210" )
        XCTAssertEqual( result, "9876543210", "Unexpect return from sanitize")
        
        result = first.sanitize( "0a1s2d3f.4g5h6j7k8l9;" )
        XCTAssertEqual( result, "0123456789", "Unexpect return from sanitize")
        
        result = first.sanitize( "qwertyuiopasdfghjkl" )
        XCTAssertEqual( result, "", "Unexpect return from sanitize")
        
        result = first.sanitize( "" )
        XCTAssertEqual( result, "", "Unexpect return from sanitize")
    }
    
    func testNewCursorPosition() {
        let textField = UITextField()
        
        textField.text = ""
        var range = NSMakeRange( 0, 0 )
        var string = "9"
        var cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 1, "Unexpect length return from buildSanitizedRange")

        textField.text = "9"
        range = NSMakeRange( 1, 0 )
        string = "8"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 2, "Unexpect length return from buildSanitizedRange")

        textField.text = "98"
        range = NSMakeRange( 2, 0 )
        string = "7"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 3, "Unexpect length return from buildSanitizedRange")

        textField.text = "987"
        range = NSMakeRange( 3, 0 )
        string = "6"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 7, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 6"
        range = NSMakeRange( 7, 0 )
        string = "5"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 8, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 65"
        range = NSMakeRange( 8, 0 )
        string = "4"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 9, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 654"
        range = NSMakeRange( 9, 0 )
        string = "3"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 13, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 654 - 3"
        range = NSMakeRange( 13, 0 )
        string = "2"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 14, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 654 - 32"
        range = NSMakeRange( 14, 0 )
        string = "1"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 15, "Unexpect length return from buildSanitizedRange")

        textField.text = "(987) 654 - 321"
        range = NSMakeRange( 15, 0 )
        string = "0"
        cursor = first.newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 16, "Unexpect length return from buildSanitizedRange")
    }
    
    func setupAndDoTheTest( startWith initalValue:String, select selectedRange:NSRange, newString:String, expectedResult:String ) {
        print("Starting with '\(initalValue)'")

        first.phoneNumberTxt.text = initalValue

        let value:Bool = first.textField( first.phoneNumberTxt, shouldChangeCharactersIn:selectedRange, replacementString:newString )

        let storedValue = self.first.phoneNumberTxt.text
        XCTAssertEqual( storedValue, expectedResult, "Unexpect text value in from phoneNumberTxt object")

        let expectedValue = first.sanitize( expectedResult )
        XCTAssertEqual( first.realTokenValue, expectedValue, "Unexpect text value in from realTokenValue")

        XCTAssertFalse( value, "Expected flag value return by textField function")
    }
    
    func testTextField_shouldChangeCharactersIn () {
        first.phoneNumberTxt = UITextField()
        
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210", expectedResult:"(987) 654 - 3210" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210", expectedResult:"(987) 654 - 3210" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210", expectedResult:"(987) 654 - 3210" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210", expectedResult:"(987) 654 - 3210" )

        first.phoneNumberTxt.text = ""                  // Initial Value
        var range = NSMakeRange( 0, 0 )                 // What is selected?
        var string = "9876543210"                       // new string to replace the selected text
        var value:Bool = first.textField( first.phoneNumberTxt, shouldChangeCharactersIn:range, replacementString:string )
        var storedValue = self.first.phoneNumberTxt.text
        XCTAssertEqual( storedValue, "(987) 654 - 3210", "Unexpect text value in from phoneNumberTxt object")
        XCTAssertEqual( first.realTokenValue, "9876543210", "Unexpect text value in from realTokenValue")
        XCTAssertFalse( value, "Expected flag value return by textField function")
        
        first.phoneNumberTxt.text = "(987) 654 - 3210"  // Initial Value
        range = NSMakeRange( 6, 8 )                     // What is selected? "654 - 32"
        string = "999"                                  // new string to replace the selected text
        value = first.textField( first.phoneNumberTxt, shouldChangeCharactersIn:range, replacementString:string )
        storedValue = self.first.phoneNumberTxt.text
        XCTAssertEqual( storedValue, "(987) 999 - 10", "Unexpect text value in from phoneNumberTxt object")
        XCTAssertEqual( first.realTokenValue, "98799910", "Unexpect text value in from realTokenValue")
        XCTAssertFalse( value, "Expected flag value return by textField function")
        
        first.phoneNumberTxt.text = "000"               // Initial Value
        range = NSMakeRange( 0, 3 )                     // What is selected? "000"
        string = "98765432"                             // new string to replace the selected text
        value = first.textField( first.phoneNumberTxt, shouldChangeCharactersIn:range, replacementString:string )
        storedValue = self.first.phoneNumberTxt.text
        XCTAssertEqual( storedValue, "(987) 654 - 32", "Unexpect text value in from phoneNumberTxt object")
        XCTAssertEqual( first.realTokenValue, "98765432", "Unexpect text value in from realTokenValue")
        XCTAssertFalse( value, "Expected flag value return by textField function")

        first.phoneNumberTxt.text = "(987) 654 - 3210"  // Initial Value
        range = NSMakeRange( 7, 9 )                     // What is selected? "54 - 3210"
        string = ""                                     // An empty string functions as a delete
        value = first.textField( first.phoneNumberTxt, shouldChangeCharactersIn:range, replacementString:string )
        storedValue = self.first.phoneNumberTxt.text
        XCTAssertEqual( storedValue, "(987) 6", "Unexpect text value in from phoneNumberTxt object")
        XCTAssertEqual( first.realTokenValue, "9876", "Unexpect text value in from realTokenValue")
        XCTAssertFalse( value, "Expected flag value return by textField function")

    }
}
