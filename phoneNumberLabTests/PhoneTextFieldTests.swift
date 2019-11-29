//
//  PhoneTextFieldTests.swift
//  phoneNumberLabTests
//
//  Created by Tom Stamm on 11/21/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import XCTest
@testable import phoneNumberLab

class testPhoneTextField: XCTestCase {
    
    let phoneVC = PhoneVC()
    let phonenumberText = PhoneTextField( frame:CGRect( x:10, y:10, width:10, height:10) )
    let currentErrorCode:PhoneNumberErrors = .noError

    override func setUp() {
        phonenumberText.errorDelegate = self
        
        phoneVC.phoneNumberTxt = phonenumberText
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLookup() {
        var result = phonenumberText.lookup[0]
        XCTAssertEqual( result, 0, "Unexpect return from lookup")

        result = phonenumberText.lookup[1]
        XCTAssertEqual( result, 0, "Unexpect return from lookup")

        result = phonenumberText.lookup[2]
        XCTAssertEqual( result, 1, "Unexpect return from lookup")

        result = phonenumberText.lookup[3]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = phonenumberText.lookup[4]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = phonenumberText.lookup[5]
        XCTAssertEqual( result, 2, "Unexpect return from lookup")

        result = phonenumberText.lookup[6]
        XCTAssertEqual( result, 3, "Unexpect return from lookup")

        result = phonenumberText.lookup[7]
        XCTAssertEqual( result, 4, "Unexpect return from lookup")

        result = phonenumberText.lookup[8]
        XCTAssertEqual( result, 5, "Unexpect return from lookup")

        result = phonenumberText.lookup[9]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = phonenumberText.lookup[10]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = phonenumberText.lookup[11]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = phonenumberText.lookup[12]
        XCTAssertEqual( result, 6, "Unexpect return from lookup")

        result = phonenumberText.lookup[13]
        XCTAssertEqual( result, 7, "Unexpect return from lookup")

        result = phonenumberText.lookup[14]
        XCTAssertEqual( result, 8, "Unexpect return from lookup")

        result = phonenumberText.lookup[15]
        XCTAssertEqual( result, 9, "Unexpect return from lookup")
    }

    func testReverseLookup() {
        var result = phonenumberText.reverseLookup[0]
        XCTAssertEqual( result, 1, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[1]
        XCTAssertEqual( result, 2, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[2]
        XCTAssertEqual( result, 3, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[3]
        XCTAssertEqual( result, 6, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[4]
        XCTAssertEqual( result, 7, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[5]
        XCTAssertEqual( result, 8, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[6]
        XCTAssertEqual( result, 9, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[7]
        XCTAssertEqual( result, 13, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[8]
        XCTAssertEqual( result, 14, "Unexpect return from reverseLookup")
        
        result = phonenumberText.reverseLookup[9]
        XCTAssertEqual( result, 15, "Unexpect return from reverseLookup")
    }
    
    func testSanitize() {
        var result = phonenumberText.sanitize( "(987) 654 - 3210" )
        XCTAssertEqual( result, "9876543210", "Unexpect return from sanitize")
        
        result = phonenumberText.sanitize( "0a1s2d3f.4g5h6j7k8l9;" )
        XCTAssertEqual( result, "0123456789", "Unexpect return from sanitize")
        
        result = phonenumberText.sanitize( "qwertyuiopasdfghjkl" )
        XCTAssertEqual( result, "", "Unexpect return from sanitize")
        
        result = phonenumberText.sanitize( "" )
        XCTAssertEqual( result, "", "Unexpect return from sanitize")
    }
    
    func testNewCursorPosition() {
        var text = ""
        var range = NSMakeRange( 0, 0 )
        var string = "9"
        var cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 1, "Unexpect length return from buildSanitizedRange")

        text = "9"
        range = NSMakeRange( 1, 0 )
        string = "8"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 2, "Unexpect length return from buildSanitizedRange")

        text = "98"
        range = NSMakeRange( 2, 0 )
        string = "7"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 3, "Unexpect length return from buildSanitizedRange")

        text = "987"
        range = NSMakeRange( 3, 0 )
        string = "6"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 7, "Unexpect length return from buildSanitizedRange")

        text = "(987) 6"
        range = NSMakeRange( 7, 0 )
        string = "5"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 8, "Unexpect length return from buildSanitizedRange")

        text = "(987) 65"
        range = NSMakeRange( 8, 0 )
        string = "4"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 9, "Unexpect length return from buildSanitizedRange")

        text = "(987) 654"
        range = NSMakeRange( 9, 0 )
        string = "3"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 13, "Unexpect length return from buildSanitizedRange")

        text = "(987) 654 - 3"
        range = NSMakeRange( 13, 0 )
        string = "2"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 14, "Unexpect length return from buildSanitizedRange")

        text = "(987) 654 - 32"
        range = NSMakeRange( 14, 0 )
        string = "1"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 15, "Unexpect length return from buildSanitizedRange")

        text = "(987) 654 - 321"
        range = NSMakeRange( 15, 0 )
        string = "0"
        cursor = phonenumberText.newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )
        XCTAssertEqual( cursor, 16, "Unexpect length return from buildSanitizedRange")
    }
    
    func testLegalCopyPasteBuffer() {
        var result = phonenumberText.legalCopyPasteBuffer( "0987654321 (-)" )
        XCTAssertTrue( result, "Expected flag value return by legalCopyPasteBuffer function")
        
        result = phonenumberText.legalCopyPasteBuffer( "" )
        XCTAssertTrue( result, "Expected flag value return by legalCopyPasteBuffer function")

        result = phonenumberText.legalCopyPasteBuffer( "abc" )
        XCTAssertFalse( result, "Expected flag value return by legalCopyPasteBuffer function")

        result = phonenumberText.legalCopyPasteBuffer( "a0987654321 (-)" )
        XCTAssertFalse( result, "Expected flag value return by legalCopyPasteBuffer function")
        
        result = phonenumberText.legalCopyPasteBuffer( "0987654321 (-)?" )
        XCTAssertFalse( result, "Expected flag value return by legalCopyPasteBuffer function")
        
        result = phonenumberText.legalCopyPasteBuffer( "09876~54321 (-)" )
        XCTAssertFalse( result, "Expected flag value return by legalCopyPasteBuffer function")
    }
    
    func setupAndDoTheTest( startWith initalValue:String, select selectedRange:NSRange, newString:String, expectedResult:String ) {
        let subText:String = (initalValue as NSString ).substring( with:selectedRange ) as String
        print("\nStarting with '\(initalValue)'; selected range is \(selectedRange) = ('\(subText)').")
        
        let expectedValue = phonenumberText.sanitize( expectedResult )
        print("Replace Selected range with '\(newString)'.  The expected string result is '\(expectedResult)' and the expected token value is '\(expectedValue)'.")

        phonenumberText.text = initalValue

        // Save reference values for the handleTextFieldDidChange call
        phonenumberText.handleTextField( phonenumberText, shouldChangeCharactersIn:selectedRange, replacementString:newString )
        
        XCTAssertNotNil( phonenumberText.refText, "Unexpected NIL value in from phoneNumberTxt.refText")
        XCTAssertNotNil( phonenumberText.refRange, "Unexpected NIL value in from phoneNumberTxt.refRange")
        XCTAssertNotNil( phonenumberText.refString, "Unexpected NIL value in from phoneNumberTxt.refString")

        // Format the phone number using values saved by handleTextField
        phonenumberText.textFieldDidChange( phonenumberText )

        let storedValue = self.phonenumberText.text
        XCTAssertEqual( storedValue, expectedResult, "Unexpect text value in from phoneNumberTxt object")

        XCTAssertEqual( phonenumberText.token, expectedValue, "Unexpect text value in from token value")
    }
    
    func testTextField_shouldChangeCharactersIn () {
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210", expectedResult:"(987) 654 - 3210" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210x", expectedResult:"" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210y", expectedResult:"" )
        setupAndDoTheTest( startWith:"", select:NSMakeRange( 0, 0 ), newString:"9876543210z", expectedResult:"" )

        setupAndDoTheTest( startWith:"(987) 654 - 3210", select:NSMakeRange( 6, 8 ), newString:"999", expectedResult:"(987) 999 - 10" )
        setupAndDoTheTest( startWith:"000", select:NSMakeRange( 0, 3 ), newString:"98765432", expectedResult:"(987) 654 - 32" )
        setupAndDoTheTest( startWith:"(987) 654 - 3210", select:NSMakeRange( 7, 9 ), newString:"", expectedResult:"(987) 6" )
    }
    
    func paste( _ string :String? ) {
        UIPasteboard.general.string = string
        if let pasteString = UIPasteboard.general.string {
            phonenumberText.insertText( pasteString )
        }
    }
    
    func selectRange( startAt:Int, forLength:Int ) {
        let endAt = startAt + forLength
        if let startPosition = phonenumberText.position( from:phonenumberText.beginningOfDocument, offset:( startAt ) ),
            let endPosition = phonenumberText.position( from:phonenumberText.beginningOfDocument, offset:( endAt ) ) {

            phonenumberText.selectedTextRange = phonenumberText.textRange( from:startPosition, to:endPosition )
        }
    }
    
    func testCopyPaste() {
        phonenumberText.text = ""
        selectRange( startAt:0, forLength:0 )
        paste( "9876543210" )
        
        XCTAssertEqual( phonenumberText.text, "9876543210", "Unexpect text value in from token value")
        
        selectRange( startAt:0, forLength:10 )
        paste( "9999999999" )
        
        XCTAssertEqual( phonenumberText.text, "9999999999", "Unexpect text value in from token value")
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
