//
//  LogInVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 21.08.2025.
//
import RxSwift
import RxCocoa

class LogInVM: AnyLogInVM {
    var credentionalsCollectVM: AnyCredentionalsCollectVM {
        self._credentionalsCollectVM
    }
    
    private let _credentionalsCollectVM: CredentionalsCollectVM
    private let logInUseCase: LogInUseCase
    private let onSuccess: () -> Void
    
    init(credentionalsCollectVM: CredentionalsCollectVM,
         logInUseCase: LogInUseCase,
         onLogIn onSuccess: @escaping () -> Void) {
        self._credentionalsCollectVM = credentionalsCollectVM
        self.logInUseCase = logInUseCase
        self.onSuccess = onSuccess
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        input.onLogInAction
            .do(onNext: { [weak self] in self?._credentionalsCollectVM.allowShowValidation()})
            .withLatestFrom(self._credentionalsCollectVM.validCredentionals)
            .compactMap {$0}
            .flatMapLatest {[logInUseCase] in
                logInUseCase.logIn(phone: $0.phoneNumber, password: $0.password).asDriver(onErrorDriveWith: .empty())
            }.drive(onNext: {[weak self] in self?.onSuccess()})
            .disposed(by: disposeBag)
        return Output()
    }
}
