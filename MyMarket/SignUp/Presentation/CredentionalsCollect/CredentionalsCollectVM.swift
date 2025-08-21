//
//  CredentionalsCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import RxSwift
import RxCocoa

class CredentionalsCollectVM: AnyCredentionalsCollectVM {
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
    
    private let _userPhoneTFVM = MyPhoneTextFieldVM(
        validator: {$0.isEmpty ? "Введіть телефон" : nil}
    )
    private let _passwordTFVM = MyTextFieldVM(
        validator: {$0.isEmpty ? "Введіть пароль" : nil}
    )
    
    func allowShowValidation() {
        self._passwordTFVM.displayValidationAllowed = true
        self._userPhoneTFVM.displayValidationAllowed = true
    }
}
