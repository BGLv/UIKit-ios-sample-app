//
//  AnyMyTextFieldVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 18.08.2025.
//
import RxSwift
import RxCocoa

struct MyTextFieldInput {
    let text: Driver<String>
}

struct MyTextFieldOutput {
    let title: Driver<String>
    let text: Driver<String>
    let isValid: Driver<Bool>
    let validationText: Driver<String>
}

protocol AnyMyTextFieldVM {
    typealias Input = MyTextFieldInput
    typealias Output = MyTextFieldOutput
    
    func transform(_: Input, disposeBag: DisposeBag) -> Output
}
