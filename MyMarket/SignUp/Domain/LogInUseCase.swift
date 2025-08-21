//
//  LogInUseCase.swift
//  MyMarket
//
//  Created by Bohdan Huk on 21.08.2025.
//
import RxSwift

protocol LogInUseCase {
    func logIn(phone: String, password: String) -> Single<Void>
}

class StubLogInUseCase: LogInUseCase {
    func logIn(phone: String, password: String) -> Single<Void> {
        return .just(())
    }
}
