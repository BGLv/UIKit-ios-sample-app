//
//  ProfileCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//

import RxSwift
import RxCocoa

struct ProfileData {
    let phone: String
    let username: String
    let email: String
    let password: String
}

class ProfileCollectVM: AnyProfileCollectVM {
    // MARK: - Public
    
    var validProfile: Driver<ProfileData?> {
        let passwordInfo = Driver.combineLatest(
            self._passwordTFVM.textDriver,
            self._passwordTFVM.isValid,
            self._confirmPasswordTFVM.textDriver
        ) { password, isValid, confirmPassword in
            (password: password, isValid: isValid && password == confirmPassword)
        }
        
        return Driver.combineLatest(
            self._userPhoneTFVM.textDriver,
            self._userPhoneTFVM.isValid,
            self._usernameTFVM.textDriver,
            self._usernameTFVM.isValid,
            self._emailTFVM.textDriver,
            self._emailTFVM.isValid,
            passwordInfo
        ) { userPhone, isPhoneValid,
            username, isUsernameValid,
            email, isEmailValid,
            passwordInfo -> ProfileData? in
            
            guard isUsernameValid,
                  isEmailValid,
                  passwordInfo.isValid else {
                return nil
            }
            
            return ProfileData(phone: userPhone, username: username, email: email, password: passwordInfo.password)
        }
    }
    var userPhoneTFVM: any AnyMyPhoneNumberTextFieldVM { self._userPhoneTFVM }
    var usernameTFVM: any AnyMyTextFieldVM { self._usernameTFVM }
    var emailTFVM: any AnyMyTextFieldVM { self._emailTFVM }
    var passwordTFVM: any AnyMyTextFieldVM { self._passwordTFVM }
    var confirmPasswordTFVM: any AnyMyTextFieldVM { self._confirmPasswordTFVM }
    
    // MARK: - Private
    private let _userPhoneTFVM = MyPhoneTextFieldVM(
        title: "Phone Number",
        validator: { $0.isEmpty ? "Please enter your phone number" : nil }
    )
    
    private let _usernameTFVM = MyTextFieldVM(
        title: "Username",
        validator: { $0.isEmpty ? "Please enter a username" : nil }
    )
    
    private let _emailTFVM = MyTextFieldVM(
        title: "Email",
        validator: { text in
            if text.isEmpty {
                return "Please enter an email"
            }
            return text.contains("@") ? nil : "Invalid email address"
        }
    )
    
    private let _passwordTFVM = MyTextFieldVM(
        title: "Password",
        validator: { $0.isEmpty ? "Please enter a password" : nil }
    )
    
    private let _confirmPasswordTFVM = MyTextFieldVM(
        title: "Confirm Password",
        validator: { $0.isEmpty ? "Please confirm your password" : nil }
    )
    
    // MARK: - Public helpers
    
    func allowShowValidation() {
        self._userPhoneTFVM.displayValidationAllowed = true
        self._usernameTFVM.displayValidationAllowed = true
        self._emailTFVM.displayValidationAllowed = true
        self._passwordTFVM.displayValidationAllowed = true
        self._confirmPasswordTFVM.displayValidationAllowed = true
    }
}
