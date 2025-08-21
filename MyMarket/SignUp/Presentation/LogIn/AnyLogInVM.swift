//
//  AnyLogInVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 21.08.2025.
//
import RxSwift
import RxCocoa

struct LogInInput {
    let onLogInAction: Driver<Void>
}

struct LogInOutput {
    
}

protocol AnyLogInVM {
    typealias Input = LogInInput
    typealias Output = LogInOutput
    
    var credentionalsCollectVM: AnyCredentionalsCollectVM { get }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
