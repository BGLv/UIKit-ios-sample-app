//
//  OTPConfirmationVC.swift
//  MyMarket
//
//  Created by Bohdan Huk on 25.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class OTPConfirmationVC: UIViewController {
    typealias ViewModel = AnyOTPConfirmationVM
    
    private lazy var otpView = OTPView()
    
    private lazy var sendCodeAgainBtn = {
        let result = UIButton(type: .custom)
        let attributedText = self.attrStrForSendAgainBtn(text: "Send SMS again")
        result.setAttributedTitle(attributedText, for: .normal)
        return result
    }()
    
    private lazy var contentView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.spacing = 10
        result.addArrangedSubview(otpView)
        result.addArrangedSubview(sendCodeAgainBtn)
        return result
    }()
    
    private lazy var companyLogoVC = CompanyLogoContainerVC(contentView: self.contentView)
    
    var viewModel: ViewModel!
    private var disposeBag = DisposeBag()
    
    convenience init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(self.companyLogoVC)
        self.view.addInscribed(self.companyLogoVC.view)
        self.companyLogoVC.didMove(toParent: self)
        
        self.companyLogoVC.updateContentInsents(.init(top: 50, left: 25, bottom: 25, right: 25))
        
        self.bind()
    }
    
    private func bind() {
        self.disposeBag = DisposeBag()
        let input = ViewModel.Input(
            otp: self.otpView.otp,
            sendSmsAgain: self.sendCodeAgainBtn.rx.tap.asDriver()
        )
        let output = self.viewModel.transform(input, disposeBag: self.disposeBag)
        [
            Driver.combineLatest(
                output.sendSmsText,
                output.sendSmsAllowed
            ) { [weak self] title, sendSmsAllowed in
                self?.sendCodeAgainBtn.isEnabled = sendSmsAllowed
                let attrTitle = self?.attrStrForSendAgainBtn(
                    text: title,
                    color: sendSmsAllowed ? .systemBlue : .systemGray
                )
                self?.sendCodeAgainBtn.setAttributedTitle(attrTitle, for: .normal)
            }.drive()
        ].forEach {$0.disposed(by: self.disposeBag)}
    }
    
    private func attrStrForSendAgainBtn(text: String, color: UIColor = UIColor.systemBlue) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)
            ]
        )
    }
}
