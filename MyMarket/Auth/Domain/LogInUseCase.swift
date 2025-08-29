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

class LogInUseCaseImpl: LogInUseCase {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func logIn(phone: String, password: String) -> Single<Void> {
        self.authService.logIn(phone: phone, password: password)
            .map { authToken in
            return
        }
    }
}

class StubLogInUseCase: LogInUseCase {
    func logIn(phone: String, password: String) -> Single<Void> {
        return .just(())
    }
}
