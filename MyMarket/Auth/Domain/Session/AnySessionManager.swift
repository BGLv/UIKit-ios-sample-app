//
//  AnySessionManager.swift
//  MyMarket
//
//  Created by Bohdan Huk on 29.08.2025.
//

import RxSwift
import RxCocoa

protocol AnySessionManager {
    func session() -> Single<Session>
    func start(session: Session) -> Completable
    func invalidate() -> Completable
}
