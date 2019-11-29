//
//  PhoneTextField.swift
//  phoneNumberLab
//
//  Created by Tom Stamm on 11/21/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import UIKit

enum PhoneNumberErrors {
    case noError, overflowError, illegalCharacterError
}

protocol PhoneTextFieldProtocol {
    func phoneNumberTextGeneratedError( _ error:PhoneNumberErrors )
}

class PhoneTextField: UITextField {
    var refInitialSelection:UITextRange?
    var refText:String?
    var refRange:NSRange?
    var refString:String?

    let maxPhoneDigits:Int = 10

    let lookup:[Int] = [ 0, 0, 1, 2, 2, 2, 3, 4, 5, 6, 6, 6, 6, 7, 8, 9, 10 ]
    let reverseLookup:[Int] = [ 1, 2, 3, 6, 7, 8, 9, 13, 14, 15, 16 ]

    var token:String = ""
    override var text:String?
    {
        didSet{
            if let text = text {
                token = sanitize( text )
            }
        }
    }

    var errorDelegate:PhoneTextFieldProtocol?
    override var delegate:UITextFieldDelegate?
    {
        didSet{
            errorDelegate = delegate as? PhoneTextFieldProtocol
        }
    }

    override init( frame:CGRect ) {
        super.init( frame:frame )

        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        super.init( coder:coder )

        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func sanitize( _ inString:String ) -> String {
        let components = inString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let outString = components.joined(separator: "")

        return outString
    }

    func legalCopyPasteBuffer( _  string:String ) -> Bool {
        let legalCharacterSet = CharacterSet( charactersIn:"0123456789 ()-" )
        let components = string.components( separatedBy:legalCharacterSet.inverted )

        return ( components.count == 1 )
    }

    func formatPhoneNumber( _ inPhoneNumber:NSString ) -> NSString {
        let length = inPhoneNumber.length
        var index = 0 as Int
        let formattedString = NSMutableString()
        let hasLeadingOne = length > 0 && inPhoneNumber.hasPrefix("1")

        if hasLeadingOne {
//            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = inPhoneNumber.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = inPhoneNumber.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@ - ", prefix)
            index += 3
        }

        let remainder = inPhoneNumber.substring(from: index)
        formattedString.append(remainder)

        return formattedString
    }

    func newCursorPosition(_ text: String, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Int {
        let orgText:String = text
        let orgSubText:String = (text as NSString ).substring( with:range ) as String
        let theoreticalCursor:Int = range.location + range.length

        var newTheoreticalCursor:Int = theoreticalCursor
        if orgText.count > 3 {
            if string == "" {   // delete
                newTheoreticalCursor = lookup[ theoreticalCursor - 1 ]
            } else {
                newTheoreticalCursor = lookup[ theoreticalCursor ]
            }
        }

        let newSubText:String = sanitize( orgSubText )
        let newString:String = sanitize( string )
        let delta:Int = newString.count - newSubText.count

        newTheoreticalCursor += delta
        if( newTheoreticalCursor > 10 ) {   // This could happen if the first character in the paste block is a "1"
            newTheoreticalCursor = 10
        }

        var newCursorPosition = newTheoreticalCursor
        if orgText.count > 2 || newString.count > 3 {
            if( string == "" ) { // This is a delete
                newCursorPosition = range.location
            } else {
                if newTheoreticalCursor >= 0 {
                    newCursorPosition = reverseLookup[ newTheoreticalCursor ]
                } else {
                    newCursorPosition = 1 // We will have to edge case test this line
                }
            }
        }

        return newCursorPosition
    }

    func handleError( _ error:PhoneNumberErrors ) {
        DispatchQueue.main.async {
            // Reset textField to original values.
            self.text = self.refText                            // There is an error restore the original text.
            self.selectedTextRange = self.refInitialSelection   // Restore the original selection.
            
            // Hand off error to delegate
            self.errorDelegate?.phoneNumberTextGeneratedError( error )
        }
    }

    @objc func textFieldDidChange( _ textField: UITextField ) {
        if legalCopyPasteBuffer( refString ?? "" ) {
            if let text = refText,
               let range  = refRange,
               let string = refString {

                let newString = (text as NSString).replacingCharacters(in: range, with: string)
                let decimalString = sanitize( newString ) as NSString
                let formattedString = formatPhoneNumber( decimalString )
                let sanitizedTokenValue = sanitize( formattedString as String )

                if sanitizedTokenValue.count <= 10 {
                    let cursor = newCursorPosition( text, shouldChangeCharactersIn:range, replacementString:string )

                    self.text = formattedString as String

                    if( string == "" ) { // delete
                        if let newPosition = self.position( from:self.beginningOfDocument, offset:(range.location) ) {
                            DispatchQueue.main.async {
                                self.selectedTextRange = self.textRange( from:newPosition, to:newPosition )
                            }
                        }
                    } else {
                        if let newPosition = self.position( from:self.beginningOfDocument, offset:( cursor ) ) {
                             DispatchQueue.main.async {
                                self.selectedTextRange = self.textRange( from:newPosition, to:newPosition )
                            }
                        }
                    }

                } else {
                    handleError( .overflowError )
                }
            }
        } else {
            handleError( .illegalCharacterError )
        }
    }
    
    func handleTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {

        // Save reference values to be used in formatting later in textFieldDidChange
        refInitialSelection = self.selectedTextRange
        refText = textField.text
        refRange = range
        refString = string

        return
    }
}
