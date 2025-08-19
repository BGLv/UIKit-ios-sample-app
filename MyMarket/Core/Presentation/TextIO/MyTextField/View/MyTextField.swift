//
//  MyTextField.swift
//  MyMarket
//
//  Created by Bohdan Huk on 18.08.2025.
//
import UIKit
import RxSwift
import RxCocoa

class MyTextField: UIView {
    private(set) lazy var textField: UITextField = {
        let textField = self.buildTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let widthConstr = textField.widthAnchor.constraint(equalToConstant: 200)
        widthConstr.priority = .defaultHigh
        widthConstr.isActive = true
        let heightConstr = textField.heightAnchor.constraint(equalToConstant: 32)
        heightConstr.priority = .defaultHigh
        heightConstr.isActive = true
        return textField
    }()
    
    private lazy var underline: UIView = {
        let result = UIView()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.heightAnchor.constraint(equalToConstant: 1).isActive = true
        result.backgroundColor = .systemGray
        return result
    }()
    
    private lazy var errorLabel: UILabel = {
        let result = UILabel()
        result.text = "mock error"
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = .systemFont(ofSize: 12, weight: .regular)
        result.textColor = .systemRed
        result.numberOfLines = 0
        result.textAlignment = .left
        return result
    }()
    
    private lazy var contentSV = { () -> UIStackView in
        let result = UIStackView()
        result.axis = .vertical
        return result
    }()
    
    private var viewModel: AnyMyTextFieldVM?
    private var disposeBag = DisposeBag()
    
    func bind(_ viewModel: AnyMyTextFieldVM) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        let input = MyTextFieldInput(
            text: self.textField.rx.text.orEmpty.asDriver()
        )
        let output = viewModel.transform(input, disposeBag: self.disposeBag)
        
        [
            output.text.drive(self.textField.rx.text),
            output.validationText.map {$0.isEmpty ? " " : $0}
                .drive(self.errorLabel.rx.text),
            output.isValid.drive(onNext: { [weak self] isValid in
                self?.errorLabel.alpha = isValid ? 0 : 1
            })
        ].forEach {$0.disposed(by: self.disposeBag)}
    }
    
    func buildTextField() -> UITextField {
        UITextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.addInscribed(self.contentSV)
        self.contentSV.addArrangedSubview(self.textField)
        self.contentSV.addArrangedSubview(self.underline)
        self.contentSV.addArrangedSubview(self.errorLabel)
    }
}
