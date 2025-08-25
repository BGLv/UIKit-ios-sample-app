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
        
        /*
        let confirmationVM = OTPConfirmationVM()
        let confirmationVC = OTPConfirmationVC(viewModel: confirmationVM)
        self.addChild(confirmationVC)
        self.view.addInscribed(confirmationVC.view)
        confirmationVC.didMove(toParent: self)
         */
        
        let navContr = UINavigationController()
        self.addChild(navContr)
        self.view.addInscribed(navContr.view)
        navContr.didMove(toParent: self)
        
        let authCoord = AuthCoordinator(navigationController: navContr)
        authCoord.start()
    }


}

protocol AnyViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_: Input) -> Output
}




