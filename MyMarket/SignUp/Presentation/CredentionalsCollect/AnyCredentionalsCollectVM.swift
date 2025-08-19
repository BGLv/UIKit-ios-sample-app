//
//  AnyCredentionalsCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import RxSwift
import RxCocoa

struct CredentionalsCollectInput {
    let collectActionEvent: Driver<Void>
}

struct CredentionalsCollectOutput {
    let collectActionTitle: Driver<String>
    let collectActionAllowed: Driver<Bool>
}

protocol AnyCredentionalsCollectVM {
    typealias Input = CredentionalsCollectInput
    typealias Output = CredentionalsCollectOutput
    
    var userPhoneTFVM: AnyMyPhoneNumberTextFieldVM {get}
    var passwordTFVM: AnyMyTextFieldVM  {get}
    
    func transform(_: Input, disposeBag: DisposeBag) -> Output
}
