//
//  CredentionalsCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import RxSwift
import RxCocoa

class CredentionalsCollectVM: AnyCredentionalsCollectVM {
    
    // MARK: - Public
    var validCredentionals: Driver<Credentionals?> {
        Driver.combineLatest(
            self._passwordTFVM.textDriver,
            self._passwordTFVM.isValid,
            self._userPhoneTFVM.textDriver,
            self._userPhoneTFVM.isValid
        ) { password, isPasswordValid, phoneNumber, isPhoneNumberValid -> Credentionals? in
            guard isPasswordValid && isPhoneNumberValid else {
                return nil
            }
            return Credentionals(phoneNumber: phoneNumber, password: password)
        }
    }
    
    var userPhoneTFVM: any AnyMyPhoneNumberTextFieldVM {
        self._userPhoneTFVM
    }
    
    var passwordTFVM: any AnyMyTextFieldVM {
        self._passwordTFVM
    }
    
    // MARK: - Private
    private let _userPhoneTFVM = MyPhoneTextFieldVM(
        title: "Phone Number",
        validator: { $0.isEmpty ? "Please enter your phone number" : nil }
    )
    
    private let _passwordTFVM = MyTextFieldVM(
        title: "Password",
        validator: { $0.isEmpty ? "Please enter your password" : nil }
    )
    
    // MARK: - Public helpers
    func allowShowValidation() {
        self._passwordTFVM.displayValidationAllowed = true
        self._userPhoneTFVM.displayValidationAllowed = true
    }
}

