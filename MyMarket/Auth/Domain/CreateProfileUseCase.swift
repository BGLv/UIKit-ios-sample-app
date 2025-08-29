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

class CreateProfileUseCaseImpl: CreateProfileUseCase {
    private let authService: AuthService
    private let sessionManager: AnySessionManager
    
    init(authService: AuthService,
         sessionManager: AnySessionManager) {
        self.authService = authService
        self.sessionManager = sessionManager
    }
    
    func createProfile(phone: String, userName: String, email: String, password: String) -> Single<Void> {
        return self.authService.signUp(phone: phone, userName: userName, email: email, password: password)
            .flatMap { [sessionManager] authToken in
                let session = Session(token: authToken.token, refreshToken: authToken.refreshToken, expiresAt: authToken.expiresAt)
                return sessionManager.start(session: session).andThen(.just(()))
            }
    }
}

class StubCreateProfileUseCase: CreateProfileUseCase {
    func createProfile(phone: String, userName: String, email: String, password: String) -> Single<Void> {
        return .just(())
    }
}
