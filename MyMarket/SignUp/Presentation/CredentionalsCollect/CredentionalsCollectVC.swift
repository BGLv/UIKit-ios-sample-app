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
    
    private lazy var phoneTextField = MyPhoneNumberTextField()
    private lazy var passwordTextField = MyTextField()
    private lazy var collectActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Collect", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var contentSV = { () -> UIStackView in
        let result = UIStackView(arrangedSubviews: [
            self.phoneTextField,
            self.passwordTextField,
            self.collectActionButton
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
        
        let input = ViewModel.Input(
            collectActionEvent: self.collectActionButton.rx.tap.asDriver()
        )
        let output = self.viewModel.transform(input, disposeBag: self.disposeBag)
        [
        output.collectActionTitle.drive(
            self.collectActionButton.rx.title(for: .normal)
        ),
        output.collectActionAllowed.drive(onNext: { [weak self] allowed in
            guard let self = self else {return}
            self.collectActionButton.isEnabled = allowed
        })
        ].forEach { $0.disposed(by: self.disposeBag) }
    }
}
