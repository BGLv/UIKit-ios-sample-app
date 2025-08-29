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
    private let sessionManager: AnySessionManager
    
    init(authService: AuthService,
         sessionManager: AnySessionManager) {
        self.authService = authService
        self.sessionManager = sessionManager
    }
    
    func logIn(phone: String, password: String) -> Single<Void> {
        self.authService.logIn(phone: phone, password: password)
            .flatMap { [sessionManager] authToken in
                let session = Session(
                    token: authToken.token,
                    refreshToken: authToken.refreshToken,
                    expiresAt: authToken.expiresAt
                )
                return sessionManager.start(session: session).andThen(.just(()))
        }
    }
}

class StubLogInUseCase: LogInUseCase {
    func logIn(phone: String, password: String) -> Single<Void> {
        return .just(())
    }
}
