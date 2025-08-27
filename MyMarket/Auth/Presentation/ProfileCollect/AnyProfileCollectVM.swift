//
//  AnyProfileCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//

import RxSwift
import RxCocoa

protocol AnyProfileCollectVM {
    var usernameTFVM: AnyMyTextFieldVM { get }
    var emailTFVM: AnyMyTextFieldVM { get }
    var passwordTFVM: AnyMyTextFieldVM { get }
    var confirmPasswordTFVM: AnyMyTextFieldVM { get }
}
