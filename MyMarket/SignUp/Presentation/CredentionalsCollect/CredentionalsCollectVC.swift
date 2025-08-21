//
//  CredentionalsCollectView.swift
//  MyMarket
//
//  Created by Bohdan Huk on 19.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class CredentionalsCollectVC: UIViewController {
    typealias ViewModel = AnyCredentionalsCollectVM
    
    private lazy var phoneTextField = {
        let result = MyPhoneNumberTextField()
        result.textColor = .white
        result.tintColor = .white
        return result
    }()
    
    private lazy var passwordTextField = {
        let result = MyTextField()
        result.textField.isSecureTextEntry = true
        result.textField.rightViewMode = .always
        result.textField.rightView = self.togglePasswordVisibilityBtn()
        result.textField.textColor = .white
        result.textField.tintColor = .white
        return result
    }()
    
    private lazy var contentSV = { () -> UIStackView in
        let result = UIStackView(arrangedSubviews: [
            self.phoneTextField,
            self.passwordTextField
        ])
        result.axis = .vertical
        result.spacing = 10
        return result
    }()
    
    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()
    
    convenience init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addInscribed(self.contentSV)
        self.bind()
    }
    
    private func bind() {
        self.disposeBag = DisposeBag()
        self.phoneTextField.bind(self.viewModel.userPhoneTFVM)
        self.passwordTextField.bind(self.viewModel.passwordTFVM)
    }
    
    private func togglePasswordVisibilityBtn() -> UIButton {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.passwordTextField.textField.isSecureTextEntry.toggle()
    }
}
