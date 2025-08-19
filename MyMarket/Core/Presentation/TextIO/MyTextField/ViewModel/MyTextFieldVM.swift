//
//  MyTextFieldVM.swift
//  MyMarket
//
//  Created by Bohdan Huk on 18.08.2025.
//
import RxSwift
import RxCocoa

class MyTextFieldVM: AnyMyTextFieldVM {
    typealias ErrorMessage = String
    
    var text: String {
        get {
            self.textBR.value
        }
        
        set {
            let modifiedText = self.textModifier(newValue)
            self.textBR.accept(modifiedText)
        }
    }
    
    var displayValidationAllowed: Bool {
        get {
            self.displayValidationAllowedBR.value
        }
        
        set {
            self.displayValidationAllowedBR.accept(newValue)
        }
    }
    
    var textDriver: Driver<String> {
        self.textBR.asDriver()
    }
    
    private let textBR: BehaviorRelay<String>
    private let validationResultBR = BehaviorRelay<ErrorMessage?>(value: "")
    private let displayValidationAllowedBR = BehaviorRelay(value: false)
    
    private let validator: (String) -> ErrorMessage?
    private let textModifier: (String) -> String
    
    init(
        text: String = "",
        validator: @escaping (String) -> ErrorMessage? = {_ in nil},
        textModifier: @escaping (String) -> String = {return $0}
    ) {
        self.textBR = BehaviorRelay(value: text)
        self.validator = validator
        self.textModifier = textModifier
    }
    
    func transform(_ input: MyTextFieldInput, disposeBag: DisposeBag) -> MyTextFieldOutput {
        
        input.text.map {[textModifier] in textModifier($0)}
            .drive(self.textBR)
            .disposed(by: disposeBag)
        
        self.textBR.asDriver()
            .map {[validator] in validator($0)}
            .drive(self.validationResultBR)
            .disposed(by: disposeBag)
        
        let validationResOut = self.validationResultBR.asDriver()
        let isValid = Driver.combineLatest(
            validationResOut.map {$0 == nil},
            self.displayValidationAllowedBR.asDriver()
        ) { $0 || !$1}
        
        let validationText = validationResOut.map {$0 ?? ""}
        
        return Output(
            text: self.textBR.asDriver(),
            isValid: isValid,
            validationText: validationText
        )
    }
    
}
