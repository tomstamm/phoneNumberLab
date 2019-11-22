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
    }

    required init?(coder: NSCoder) {
        super.init( coder:coder )
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
    
//    let lookup:[Int] = [ 0, 0, 1, 2, 2, 2, 3, 4, 5, 6, 6, 6, 6, 7, 8, 9, 10 ]
//    let reverseLookup:[Int] = [ 0, 1, 2, 3, 6, 7, 8, 12, 13, 14, 15, 16 ]

    func newCursorPosition(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Int {
        let orgText:String = textField.text ?? ""
        let orgSubText:String = (( textField.text ?? "" ) as NSString ).substring( with:range ) as String
        let theoreticalCursor:Int = range.location + range.length
        
        print("\ntextField.text:\(textField.text)")
        print("   range location:\(range.location), length:\(range.length)")
        print("   theoreticalCursor:\(theoreticalCursor)")

        var newTheoreticalCursor:Int = theoreticalCursor
        if orgText.count > 3 {
            if string == "" {   // delete
                newTheoreticalCursor = lookup[ theoreticalCursor - 1 ]
            } else {
                newTheoreticalCursor = lookup[ theoreticalCursor ]
            }
        }
  
        print("   newTheoreticalCursor:\(newTheoreticalCursor)")

        let newSubText:String = sanitize( orgSubText )
        let newString:String = sanitize( string )
        let delta:Int = newString.count - newSubText.count
        print("   newSubText:\(newSubText)")
        print("   newString:\(newString)")
        print("   delta:\(delta)")

        newTheoreticalCursor += delta
        if( newTheoreticalCursor > 10 ) {   // This could happen if the first character in the paste block is a "1"
            newTheoreticalCursor = 10
        }
        print("   newTheoreticalCursor:\(newTheoreticalCursor)")
        
        var newCursorPosition = newTheoreticalCursor
        if orgText.count > 2 || newString.count > 3 {
            if( string == "" ) { // This is a delete
                if( range.length == 1 ) {
                    newCursorPosition = range.location
                } else {
                    newCursorPosition = range.location
                }
            } else {
                if newTheoreticalCursor >= 0 {
                    newCursorPosition = reverseLookup[ newTheoreticalCursor ]
                } else {
                    newCursorPosition = 1 // We will have to edge case test this line
                }
            }
        }
        print("   newCursorPosition:\(newCursorPosition)")

        return newCursorPosition
    }
    
    func handleTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        print("string:'\(string)'")
        if legalCopyPasteBuffer( string ) {
            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            print("newString:\(newString)")
            
            let decimalString = sanitize( newString ) as NSString
            print("decimalString:\(decimalString)")
            
            let formattedString = formatPhoneNumber( decimalString )
            print("formattedString:\(formattedString)")
            
            let sanitizedTokenValue = sanitize( formattedString as String )

            if sanitizedTokenValue.count <= 10 {
                let cursor = newCursorPosition( textField, shouldChangeCharactersIn:range, replacementString:string )
                
                textField.text = formattedString as String
                
                // =========================================
                
                if( string == "" ) { // delete
                    print("0 formattedString:\(formattedString)")
                    print("   range location:\(range.location), length:\(range.length)")
                    
                    if let newPosition = textField.position( from:textField.beginningOfDocument, offset:(range.location) ) {
                        DispatchQueue.main.async {
                            textField.selectedTextRange = textField.textRange( from:newPosition, to:newPosition )
                        }
                    }
                } else {
                    print("1 formattedString:\(formattedString)")
                    print("   range location:\(range.location), length:\(range.length)")
                    print("   cursor:\(cursor)")
                    
                    if let newPosition = textField.position( from:textField.beginningOfDocument, offset:( cursor ) ) {
                        print("   newPosition:\(newPosition)")
                        DispatchQueue.main.async {
                            textField.selectedTextRange = textField.textRange( from:newPosition, to:newPosition )
                        }
                    }
                }
                
            } else {
                self.errorDelegate?.phoneNumberTextGeneratedError( .overflowError )
            }
        } else {
             self.errorDelegate?.phoneNumberTextGeneratedError( .illegalCharacterError )
            
        }
        
        return false
    }
}
