//
//  ProfileCollectVC.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileCollectVC: UIViewController {
    typealias ViewModel = AnyProfileCollectVM
    
    // MARK: - UI
    
    private lazy var phoneTextField = {
        let result = MyPhoneNumberTextField()
        result.textColor = .white
        result.tintColor = .white
        return result
    }()
    
    private lazy var usernameTextField = {
        let result = MyTextField()
        result.textField.placeholder = "Username"
        result.textField.textColor = .white
        result.textField.tintColor = .white
        return result
    }()
    
    private lazy var emailTextField = {
        let result = MyTextField()
        result.textField.placeholder = "Email"
        result.textField.keyboardType = .emailAddress
        result.textField.autocapitalizationType = .none
        result.textField.textColor = .white
        result.textField.tintColor = .white
        return result
    }()
    
    private lazy var passwordTextField = {
        let result = MyTextField()
        result.textField.placeholder = "Password"
        result.textField.isSecureTextEntry = true
        result.textField.rightViewMode = .always
        result.textField.rightView = self.togglePasswordVisibilityBtn(for: result.textField)
        result.textField.textColor = .white
        result.textField.tintColor = .white
        return result
    }()
    
    private lazy var confirmPasswordTextField = {
        let result = MyTextField()
        result.textField.placeholder = "Confirm Password"
        result.textField.isSecureTextEntry = true
        result.textField.rightViewMode = .always
        result.textField.rightView = self.togglePasswordVisibilityBtn(for: result.textField)
        result.textField.textColor = .white
        result.textField.tintColor = .white
        return result
    }()
    
    private lazy var contentSV = { () -> UIStackView in
        let result = UIStackView(arrangedSubviews: [
            self.phoneTextField,
            self.usernameTextField,
            self.emailTextField,
            self.passwordTextField,
            self.confirmPasswordTextField
        ])
        result.axis = .vertical
        result.spacing = 10
        return result
    }()
    
    // MARK: - Properties
    
    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    convenience init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addInscribed(self.contentSV)
        self.bind()
    }
    
    // MARK: - Binding
    
    private func bind() {
        self.disposeBag = DisposeBag()
        
        self.phoneTextField.bind(self.viewModel.userPhoneTFVM)
        self.usernameTextField.bind(self.viewModel.usernameTFVM)
        self.emailTextField.bind(self.viewModel.emailTFVM)
        self.passwordTextField.bind(self.viewModel.passwordTFVM)
        self.confirmPasswordTextField.bind(self.viewModel.confirmPasswordTFVM)
    }
    
    // MARK: - Helpers
    
    private func togglePasswordVisibilityBtn(for textField: UITextField) -> UIButton {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.addAction(UIAction { [weak textField, weak button] _ in
            guard let tf = textField, let btn = button else { return }
            btn.isSelected.toggle()
            tf.isSecureTextEntry.toggle()
        }, for: .touchUpInside)
        return button
    }
}
