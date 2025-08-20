//
//  MyPhoneNumberTextField.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import UIKit
import RxSwift
import RxCocoa
import PhoneNumberKit

class MyPhoneNumberTextField: UIView {
    typealias ViewModel = AnyMyPhoneNumberTextFieldVM
    
    class PNKTextField: MyTextField {
        override func buildTextField() -> UITextField {
            let result = PhoneNumberTextField()
            return result
        }
    }
    
    var textColor: UIColor? {
        get {
            self.textField.textField.textColor
        }
        
        set {
            self.textField.textField.textColor = newValue
        }
    }
    
    private(set) lazy var textField = { () -> MyTextField in
        let textField = PNKTextField()
        return textField
    }()
    
    private var viewModel: ViewModel?
    
    func bind(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        self.textField.bind(viewModel.phoneTextField)
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
        self.addInscribed(self.textField)
    }
}
