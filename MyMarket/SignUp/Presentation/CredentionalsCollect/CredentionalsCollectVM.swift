//
//  CredentionalsCollectVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import RxSwift
import RxCocoa

class CredentionalsCollectVM: AnyCredentionalsCollectVM {
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
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        input.collectActionEvent.do(onNext: { [weak self] in
            self?._passwordTFVM.displayValidationAllowed = true
            self?._userPhoneTFVM.displayValidationAllowed = true
        }).drive().disposed(by: disposeBag)
        
        return Output(
            collectActionTitle: .just("mock title"),
            collectActionAllowed: .just(true)
        )
    }
    
}
