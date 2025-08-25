//
//  AnyOTPConfirmationVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 25.08.2025.
//
import RxSwift
import RxCocoa

struct OTPConfirmationInput {
    let otp: Driver<String?>
    let sendSmsAgain: Driver<Void>
}

struct OTPConfirmationOutput {
    let sendSmsAllowed: Driver<Bool>
    let sendSmsText: Driver<String>
    
}

protocol AnyOTPConfirmationVM {
    typealias Input = OTPConfirmationInput
    typealias Output = OTPConfirmationOutput
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
