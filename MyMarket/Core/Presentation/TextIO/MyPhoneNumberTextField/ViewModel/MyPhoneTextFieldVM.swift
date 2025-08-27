//
//  MyPhoneTextFieldVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//
import RxSwift
import RxCocoa

class MyPhoneTextFieldVM: AnyMyPhoneNumberTextFieldVM {
    typealias ErrorMessage = String
    
    var phoneTextField: MyTextFieldVM
    
    var text: String {
        get {
            self.phoneTextField.text
        }
        
        set {
            self.phoneTextField.text = newValue
        }
    }
    
    var displayValidationAllowed: Bool {
        get {
            self.phoneTextField.displayValidationAllowed
        }
        
        set {
            self.phoneTextField.displayValidationAllowed = newValue
        }
    }
    
    var textDriver: Driver<String> {
        self.phoneTextField.textDriver
    }
    
    var isValid: Driver<Bool> {
        self.phoneTextField.isValid
    }
    
    init(
        title: String = "",
        text: String = "",
        validator: @escaping (String) -> ErrorMessage? = {_ in nil},
        textModifier: @escaping (String) -> String = {return $0}
    ) {
        self.phoneTextField = MyTextFieldVM(
            title: title,
            text: text,
            validator: validator,
            textModifier: textModifier
        )
    }
}
