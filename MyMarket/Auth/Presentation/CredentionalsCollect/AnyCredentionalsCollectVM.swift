//
//  AnyCredentionalsCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import RxSwift
import RxCocoa

protocol AnyCredentionalsCollectVM {
    var userPhoneTFVM: AnyMyPhoneNumberTextFieldVM {get}
    var passwordTFVM: AnyMyTextFieldVM  {get}
}
