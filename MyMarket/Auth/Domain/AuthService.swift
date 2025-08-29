//
//  AuthService.swift
//  MyMarket
//
//  Created by Bohdan Huk on 28.08.2025.
//
import RxSwift

struct AuthToken {
    let value: String
    let expiresAt: Date
}

protocol AuthService {
    func logIn(phone: String, password: String) -> Single<AuthToken>
}
