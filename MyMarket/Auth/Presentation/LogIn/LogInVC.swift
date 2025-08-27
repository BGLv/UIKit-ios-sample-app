//
//  LogInVC.swift
//  MyMarket
//
//  Created by Bohdan Huk on 21.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class LogInVC: UIViewController {
    typealias ViewModel = AnyLogInVM
    
    private lazy var contentView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.spacing = 10
        self.addChild(self.credentionalsCollectVC)
        result.addArrangedSubview(self.credentionalsCollectVC.view)
        result.addArrangedSubview(self.collectActionButton)
        result.addArrangedSubview(self.signUpButton)
        self.credentionalsCollectVC.didMove(toParent: self)
        
        self.credentionalsCollectVC.view.leadingAnchor.constraint(equalTo: result.leadingAnchor, constant: 30).isActive = true
        self.credentionalsCollectVC.view.trailingAnchor.constraint(equalTo: result.trailingAnchor, constant: -30).isActive = true
        
        self.collectActionButton.widthAnchor.constraint(
            equalTo: self.credentionalsCollectVC.view.widthAnchor, multiplier: 0.5
        ).isActive = true
        
        return result
    }()
    
    private lazy var credentionalsCollectVC = CredentionalsCollectVC(viewModel: self.viewModel.credentionalsCollectVM)
    private lazy var companyLogoContainer = CompanyLogoContainerVC(contentView: self.contentView)
    
    private lazy var collectActionButton: UIButton = {
        let button = RippleButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
      
    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(self.companyLogoContainer)
        self.view.addInscribed(self.companyLogoContainer.view)
        self.companyLogoContainer.didMove(toParent: self)
        self.bind()
    }
    
    private func bind() {
        self.disposeBag = DisposeBag()
        let input = ViewModel.Input(
            onLogInAction: self.collectActionButton.rx.tap.asDriver(),
            onSignUpAction: self.signUpButton.rx.tap.asDriver()
        )
        let output = self.viewModel.transform(input, disposeBag: disposeBag)
    }
}
