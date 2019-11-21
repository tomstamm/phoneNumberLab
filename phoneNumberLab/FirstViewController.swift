//
//  FirstViewController.swift
//  phoneNumberLab
//
//  Created by Tom Stamm on 11/18/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let maxPhoneDigits:Int = 10

    @IBOutlet var phoneNumberTxt: UITextField!
    @IBOutlet var resultLbl: UILabel!
    @IBOutlet var keypadToolBar: UIToolbar!
    @IBOutlet var positionSlider: UISlider!
    @IBOutlet var positionLbl: UILabel!
    @IBOutlet var overflowMessageLbl: UILabel!
    
    let lookup:[Int] = [ 0, 0, 1, 2, 2, 2, 3, 4, 5, 6, 6, 6, 6, 7, 8, 9, 10 ]
    let reverseLookup:[Int] = [ 1, 2, 3, 6, 7, 8, 9, 13, 14, 15, 16 ]
    
    var realTokenValue:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        phoneNumberTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        // Keyboard scolling logic
        phoneNumberTxt.delegate = self
        phoneNumberTxt.inputAccessoryView = keypadToolBar
    }


    @objc func textFieldDidChange( _ textField: UITextField ) {
        
        resultLbl.text = textField.text
    }
    
    @IBAction func NumericDone(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { () -> Void in
            self.phoneNumberTxt?.resignFirstResponder()
        }
    }
    
    @IBAction func positionChanged(_ sender: UISlider) {
        let value:Int = Int( sender.value )
        positionLbl.text = String( value )
        
        if let newPosition = phoneNumberTxt.position( from:phoneNumberTxt.beginningOfDocument, offset:(value) ) {
            phoneNumberTxt.selectedTextRange = phoneNumberTxt.textRange( from:newPosition, to:newPosition )
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension FirstViewController: UITextFieldDelegate {
    func sanitize( _ inString:String ) -> String {
        let components = inString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let outString = components.joined(separator: "")
        
        return outString
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
                newCursorPosition = reverseLookup[ newTheoreticalCursor ]
            }
        }
        print("   newCursorPosition:\(newCursorPosition)")

        return newCursorPosition
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        overflowMessageLbl.isHidden = true
        if (textField == phoneNumberTxt) {
            
            if let text = textField.text {
                positionSlider.maximumValue = Float( text.count )
                positionSlider.value = Float( range.location )
                positionLbl.text = String( range.location )
            }
            print("   string:\(string)")
            
            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            print("newString:\(newString)")
            
            let decimalString = sanitize( newString ) as NSString
            print("decimalString:\(decimalString)")
            
            let formattedString = formatPhoneNumber( decimalString )
            print("formattedString:\(formattedString)")
            
            let sanitizedTokenValue = sanitize( formattedString as String )
            resultLbl.text = sanitizedTokenValue

            if sanitizedTokenValue.count <= 10 {
                realTokenValue = sanitizedTokenValue
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
                
                if let text = textField.text {
                    positionSlider.maximumValue = Float( text.count )
                    positionSlider.value = Float( range.location )
                    positionLbl.text = String( range.location )
                }
            } else {
                print("data too big for phone number \(realTokenValue)")
                overflowMessageLbl.isHidden = false

            }
            
            return false
        } else {
            return true
        }
    }
}
