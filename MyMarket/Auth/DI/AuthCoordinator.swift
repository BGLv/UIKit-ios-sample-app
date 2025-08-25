//
//  AuthCoordinator.swift
//  MyMarket
//
//  Created by Bohdan Huk on 25.08.2025.
//
import UIKit

class AuthCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.pushViewController(buildLoginVC(), animated: true)
    }
    
    private func buildLoginVC() -> UIViewController {
        let logInVM = LogInVM(
            credentionalsCollectVM: CredentionalsCollectVM(),
            logInUseCase: StubLogInUseCase()
        )
        let logInVC = LogInVC()
        logInVC.viewModel = logInVM
        return logInVC
    }
}
