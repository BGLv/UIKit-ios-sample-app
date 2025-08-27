//
//  ProfileCreationVC.swift
//  MyMarket
//
//  Created by Bohdan Huk on 27.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileCreationVC: UIViewController {
    typealias ViewModel = AnyProfileCreationVM
    
    // MARK: - UI
    
    private lazy var profileCollectVC = ProfileCollectVC(viewModel: self.viewModel.profileCollectVM)
    
    private lazy var collectActionButton: UIButton = {
        let button = RippleButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Profile", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var contentView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.spacing = 20
        
        // embed ProfileCollectVC
        self.addChild(self.profileCollectVC)
        result.addArrangedSubview(self.profileCollectVC.view)
        self.profileCollectVC.didMove(toParent: self)
        
        // add action button
        result.addArrangedSubview(self.collectActionButton)
        
        // Constraints for width
        self.profileCollectVC.view.leadingAnchor.constraint(equalTo: result.leadingAnchor, constant: 30).isActive = true
        self.profileCollectVC.view.trailingAnchor.constraint(equalTo: result.trailingAnchor, constant: -30).isActive = true
        
        self.collectActionButton.widthAnchor.constraint(equalTo: self.profileCollectVC.view.widthAnchor, multiplier: 0.5).isActive = true
        
        return result
    }()
    
    private lazy var companyLogoContainer = CompanyLogoContainerVC(contentView: self.contentView)
    
    // MARK: - Properties
    
    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(self.companyLogoContainer)
        self.view.addInscribed(self.companyLogoContainer.view)
        self.companyLogoContainer.didMove(toParent: self)
        self.bind()
    }
    
    // MARK: - Binding
    
    private func bind() {
        self.disposeBag = DisposeBag()
        
        let input = ViewModel.Input(
            onProfileCreateAction: self.collectActionButton.rx.tap.asDriver()
        )
        let output = self.viewModel.transform(input, disposeBag: disposeBag)
    }
}
