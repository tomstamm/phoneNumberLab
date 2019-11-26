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

    @IBOutlet var phoneNumberTxt: PhoneTextField!
    @IBOutlet var resultLbl: UILabel!
    @IBOutlet var keypadToolBar: UIToolbar!
    @IBOutlet var positionSlider: UISlider!
    @IBOutlet var positionLbl: UILabel!
    @IBOutlet var overflowMessageLbl: UILabel!
    @IBOutlet var illegalDigitsMessageLbl: UILabel!
    @IBOutlet var inputBuffer: UITextView!
    @IBOutlet var clipBoardBuffer: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        // Keyboard scolling logic
        phoneNumberTxt.delegate = self
        phoneNumberTxt.inputAccessoryView = keypadToolBar
        
        phoneNumberTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Initiate buffer display
        inputBuffer.text = ""
        clipBoardBuffer.text = ""
    }

    @objc func textFieldDidChange( _ textField: UITextField ) {
        if textField == phoneNumberTxt {
            resultLbl.text = phoneNumberTxt.token
        }
    }

    @IBAction func NumericDone(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { () -> Void in
            self.phoneNumberTxt?.resignFirstResponder()
        }
    }

    @IBAction func positionChanged(_ sender: UISlider) {
        let value:Int = Int( sender.value )
        positionLbl.text = String( value )
        
        if let newPosition = self.phoneNumberTxt.position( from:self.phoneNumberTxt.beginningOfDocument, offset:(value) ) {
            self.phoneNumberTxt.selectedTextRange = self.phoneNumberTxt.textRange( from:newPosition, to:newPosition )
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension SecondViewController: UITextFieldDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        overflowMessageLbl.isHidden = true
        illegalDigitsMessageLbl.isHidden = true

        if (textField == phoneNumberTxt) {
            inputBuffer.text = string
            clipBoardBuffer.text = UIPasteboard.general.string

            phoneNumberTxt.handleTextField( textField, shouldChangeCharactersIn:range, replacementString:string)
            
            if let text = textField.text {
                positionSlider.maximumValue = Float( text.count )
                positionSlider.value = Float( range.location )
                positionLbl.text = String( range.location )
            }
        }
        
        return true
    }
}

extension SecondViewController: PhoneTextFieldProtocol {
        func phoneNumberTextGeneratedError( _ error:PhoneNumberErrors ) {
            
            switch error {
            case .noError:
                overflowMessageLbl.isHidden = true
                illegalDigitsMessageLbl.isHidden = true
                
            case .overflowError:
                print("data too big for phone number: expected length <= 10")
                overflowMessageLbl.isHidden = false
            
            case .illegalCharacterError:
                print("Non-legal characters would be added for phone number: expected characters '0123456789( -)'")
                illegalDigitsMessageLbl.isHidden = false
        }
    }
}
