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
    
    let lookup:[Int] = [ 0, 0, 1, 2, 2, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8, 9 ]
    let reverseLookup:[Int] = [ 1, 2, 3, 6, 7, 8, 12, 13, 14, 15 ]

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == phoneNumberTxt) {
            let orgStringLength:Int = textField.text?.count ?? 0
            
            print("\ntextField.text:\(textField.text)")
            print("   range location:\(range.location), length:\(range.length)")
            print("   orgStringLength:\(orgStringLength)")
            
            if let text = textField.text {
                positionSlider.maximumValue = Float( text.count )
                positionSlider.value = Float( range.location )
                positionLbl.text = String( range.location )
            }
            print("   string:\(string)")

            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            print("newString:\(newString)")
            
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            print("components:\(components)")

            let decimalString = components.joined(separator: "") as NSString
            print("decimalString:\(decimalString)")

            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.hasPrefix("1")
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            var cursorIndex = 1 as Int

            
            if hasLeadingOne {
//                formattedString.append("1 ")
                index += 1
//                cursorIndex += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
                
                cursorIndex += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@ - ", prefix)
                index += 3

//                cursorIndex += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            
            // =========================================
   
            if(( range.length == 1 ) && string == "") { // delete
                print("0 formattedString:\(formattedString)")
                print("   range location:\(range.location), length:\(range.length)")
                print("   cursorIndex:\(cursorIndex)")
                
                if let newPosition = textField.position( from:textField.beginningOfDocument, offset:(range.location) ) {
                    textField.selectedTextRange = textField.textRange( from:newPosition, to:newPosition )
                }
            } else {
                if( orgStringLength == range.location ) { // we are at the end of the string
                    print("1 formattedString:\(formattedString)")
                    print("   range location:\(range.location), length:\(range.length)")
                    print("   cursorIndex:\(cursorIndex)")
                    
                    if let newPosition = textField.position( from:textField.beginningOfDocument, offset:( range.location + cursorIndex ) ) {
                        textField.selectedTextRange = textField.textRange( from:newPosition, to:newPosition )
                    }
                } else {
                    print("2 formattedString:\(formattedString)")
                    print("   range location:\(range.location), length:\(range.length)")
                    print("   cursorIndex:\(cursorIndex)")
                    
                    if let newPosition = textField.position( from:textField.beginningOfDocument, offset:( range.location + range.length + cursorIndex - string.count ) ) {
                        textField.selectedTextRange = textField.textRange( from:newPosition, to:newPosition )
                    }
                }
            }
            
            if let text = textField.text {
                positionSlider.maximumValue = Float( text.count )
                positionSlider.value = Float( range.location )
                positionLbl.text = String( range.location )
            }

            return false
        }
        else {
            return true
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
//        var returnBool:Bool = true
//
////        if textField == phoneNumberTxt {
////            if range.length == 1 && text == "" {    // Delete Key
////                returnBool = true
////            } else {
////                let string = phoneNumberTxt.text ?? ""
////                if string.count + text.count - range.length > maxPhoneDigits { // Too Long
////                    returnBool = false
////                }
////            }
////        }
//
//        if textField == phoneNumberTxt {
//            if range.length == 1 && text == "" {    // Delete Key
//                returnBool = true
//                textField.text = [self formatPhoneNumber:totalString deleteLastChar:returnBool];
//            } else {
//                returnBool = false
//               textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
//            }
//        }
//
//
//        return returnBool
//    }
}
