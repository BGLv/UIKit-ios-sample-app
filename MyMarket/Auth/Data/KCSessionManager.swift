//
//  KCSessionManager.swift
//  MyMarket
//
//  Created by Bohdan Huk on 29.08.2025.
//

import Foundation
import RxSwift
import Security

final class KCSessionManager: AnySessionManager {    
    private enum Keys {
        static let token = "auth_token"
        static let refreshToken = "refresh_token"
        static let expiresAt = "expires_at"
    }
    
    static let shared = KCSessionManager()
    
    // MARK: - Public
    
    func session() -> Single<Session> {
        return Single.create { observer in
            guard
                let token = Self.get(KeychainKey: Keys.token),
                let refreshToken = Self.get(KeychainKey: Keys.refreshToken)
            else {
                observer(.failure(SessionError.noSession))
                return Disposables.create()
            }
            
            let expiresAtString = Self.get(KeychainKey: Keys.expiresAt)
            let expiresAt = expiresAtString.flatMap { ISO8601DateFormatter().date(from: $0) }
            
            observer(.success(Session(token: token, refreshToken: refreshToken, expiresAt: expiresAt)))
            return Disposables.create()
        }
    }
    
    func start(session: Session) -> Completable {
        return Completable.create { completable in
            do {
                try Self.save(KeychainKey: Keys.token, value: session.token)
                try Self.save(KeychainKey: Keys.refreshToken, value: session.refreshToken)
                
                if let expiresAt = session.expiresAt {
                    let formatted = ISO8601DateFormatter().string(from: expiresAt)
                    try Self.save(KeychainKey: Keys.expiresAt, value: formatted)
                }
                
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func invalidate() -> Completable {
        return Completable.create { completable in
            do {
                try Self.delete(KeychainKey: Keys.token)
                try Self.delete(KeychainKey: Keys.refreshToken)
                try Self.delete(KeychainKey: Keys.expiresAt)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}

enum SessionError: Error {
    case noSession
}

extension KCSessionManager {
    private static func save(KeychainKey key: String, value: String) throws {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) 
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SessionError.noSession
        }
    }
    
    private static func get(KeychainKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private static func delete(KeychainKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
