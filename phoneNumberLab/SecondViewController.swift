//
//  SecondViewController.swift
//  phoneNumberLab
//
//  Created by Tom Stamm on 11/18/19.
//  Copyright © 2019 Tom Stamm. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    let maxPhoneDigits:Int = 10
    
    @IBOutlet var phoneNumberTxt: UITextField!
    @IBOutlet var resultLbl: UILabel!
    @IBOutlet var keypadToolBar: UIToolbar!
    
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
}

// MARK: - UITextFieldDelegate Methods
extension SecondViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == phoneNumberTxt) {
            
            let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let decimalString = components.joined(separator: "") as NSString
            
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.hasPrefix("1")
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                //                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@ - ", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else {
            return true
        }
    }
}
