//
//  OTPView.swift
//  MyMarket
//
//  Created by Bohdan Huk on 21.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class OTPView: UIView, UITextFieldDelegate {
    var codeSize = 4
    
    var otp: Driver<String?> {
        Driver.zip(self.textFields.map {$0.rx.text.orEmpty.asDriver()})
            .map { [weak self] in
                let code = $0.joined()
                return code.count == self?.codeSize ? code : nil
            }
    }
    
    private let contentSV = {
        let result = UIStackView()
        result.axis = .horizontal
        result.spacing = 8
        return result
    }()
    
    private var textFields: [UITextField] = []
    
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
        (1...self.codeSize).forEach { _ in
            let textField = self.buildTF()
            self.contentSV.addArrangedSubview(textField)
            self.textFields.append(textField)
        }
    }
    
    private func buildTF() -> UITextField {
        let result = UITextField()
        result.backgroundColor = .white
        result.borderStyle = .roundedRect
        result.translatesAutoresizingMaskIntoConstraints = false
        result.heightAnchor.constraint(equalToConstant: 50).isActive = true
        result.widthAnchor.constraint(equalToConstant: 50).isActive = true
        result.keyboardType = .numberPad
        result.textContentType = .oneTimeCode
        result.textAlignment = .center
        result.delegate = self
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 1 {
            textField.text = string
            if let nextIndex = self.indexAfter(textField) {
                self.textFields[nextIndex].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if string.count == self.codeSize {
            self.textFields.enumerated().forEach { (index, tf) in
                tf.text = String(string.split(separator: "")[index])
            }
        } else if string.isEmpty {
            textField.text = ""
            if let indexBefore = self.indexBefore(textField) {
                self.textFields[indexBefore].becomeFirstResponder()
            }
        }
        return false
    }
    
    private func indexOf(_ textField: UITextField) -> Int? {
        var result: Int? = nil
        self.textFields.enumerated().forEach { (index, tf) in
            if tf === textField {
                result = index
            }
        }
        return result
    }
    
    private func indexAfter(_ textField: UITextField) -> Int? {
        var result: Int? = nil
        self.textFields.enumerated().forEach { (index, tf) in
            if tf === textField {
                if self.textFields.indices.contains(index + 1) {
                    result = index + 1
                }
            }
        }
        return result
    }
    
    private func indexBefore(_ textField: UITextField) -> Int? {
        var result: Int? = nil
        self.textFields.enumerated().forEach { (index, tf) in
            if tf === textField {
                if self.textFields.indices.contains(index - 1) {
                    result = index - 1
                }
            }
        }
        return result
    }
}
