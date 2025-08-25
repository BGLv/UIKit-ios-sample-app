//
//  OTPConfirmationVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 25.08.2025.
//
import RxSwift
import RxCocoa

class OTPConfirmationVM: AnyOTPConfirmationVM {
    
    private let cooldown: Int = 30
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let sendTimer = input.sendSmsAgain.startWith(())
            .flatMapLatest {[weak self] in self?.buildTimerObs() ?? .empty()}
        let sendSmsText = sendTimer
            .map { [cooldown] timePassed in
                let result: String
                if timePassed == cooldown {
                    result = "Send Sms again"
                } else {
                    result = "Send Sms after \(cooldown - timePassed) seconds"
                }
                return result
            }
        let sendSmsAllowed = sendTimer.map {[cooldown] timePassed in timePassed == cooldown}
        
        return Output(
            sendSmsAllowed: sendSmsAllowed,
            sendSmsText: sendSmsText
        )
    }
    
    private func buildTimerObs() -> Driver<Int> {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(self.cooldown + 1)
            .asDriver(onErrorDriveWith: .empty())
    }
}
