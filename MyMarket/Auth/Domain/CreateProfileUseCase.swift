//
//  CreateProfileUseCase.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//
import RxSwift

protocol CreateProfileUseCase {
    func createProfile(phone: String, userName: String, email: String, password: String) -> Single<Void>
}

class StubCreateProfileUseCase: CreateProfileUseCase {
    func createProfile(phone: String, userName: String, email: String, password: String) -> Single<Void> {
        return .just(())
    }
}
