//
//  ProfileCreationVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//

import RxSwift
import RxCocoa

class ProfileCreationVM: AnyProfileCreationVM {
    
    // MARK: - Public
    var profileCollectVM: AnyProfileCollectVM { self._profileCollectVM }
    
    // MARK: - Private
    private let _profileCollectVM: ProfileCollectVM
    private let createProfileUseCase: CreateProfileUseCase
    private let onSuccess: () -> Void
    
    // MARK: - Init
    init(profileCollectVM: ProfileCollectVM,
         createProfileUseCase: CreateProfileUseCase,
         onSuccess: @escaping () -> Void) {
        self._profileCollectVM = profileCollectVM
        self.createProfileUseCase = createProfileUseCase
        self.onSuccess = onSuccess
    }
    
    // MARK: - Transform
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.onProfileCreateAction
            .do(onNext: { [weak self] in
                self?._profileCollectVM.allowShowValidation()
            })
            .withLatestFrom(self._profileCollectVM.validProfile)
            .compactMap { $0 } // ignore invalid profiles
            .flatMapLatest { [createProfileUseCase] profileData in
                createProfileUseCase.createProfile(
                    userName: profileData.username,
                    email: profileData.email,
                    password: profileData.password
                )
                .asDriver(onErrorDriveWith: .empty())
            }
            .drive(onNext: { [weak self] _ in
                self?.onSuccess()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
