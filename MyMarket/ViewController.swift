//
//  ViewController.swift
//  MyMarket
//
//  Created by Bohdan Huk on 16.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let logInVM = LogInVM(
            credentionalsCollectVM: CredentionalsCollectVM(),
            logInUseCase: StubLogInUseCase()
        )
        let logInVC = LogInVC()
        logInVC.viewModel = logInVM
        
        self.addChild(logInVC)
        self.view.addInscribed(logInVC.view)
        logInVC.didMove(toParent: self)
        */
        
        let confirmationVM = OTPConfirmationVM()
        let confirmationVC = OTPConfirmationVC(viewModel: confirmationVM)
        self.addChild(confirmationVC)
        self.view.addInscribed(confirmationVC.view)
        confirmationVC.didMove(toParent: self)
        
    }


}

protocol AnyViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_: Input) -> Output
}




