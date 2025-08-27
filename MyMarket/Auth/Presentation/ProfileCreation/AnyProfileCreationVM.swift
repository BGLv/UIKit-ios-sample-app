//
//  AnyProfileCreationVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//
import RxSwift
import RxCocoa

struct ProfileCreationInput {
    let onProfileCreateAction: Driver<Void>
    let onAlreadyHaveAction: Driver<Void>
}

struct ProfileCreationOutput {
    
}

protocol AnyProfileCreationVM {
    typealias Input = ProfileCreationInput
    typealias Output = ProfileCreationOutput
    
    var profileCollectVM: AnyProfileCollectVM { get }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
