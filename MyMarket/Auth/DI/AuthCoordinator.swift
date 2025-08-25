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
        let logInVC = self.buildLoginVC(onLogIn: { [weak self] in
            guard let self = self else {return}
            self.navigationController.pushViewController(self.buildConfirmationVC(), animated: true)
        })
        self.navigationController.pushViewController(logInVC, animated: true)
    }
    
    private func buildLoginVC(onLogIn: @escaping () -> Void) -> UIViewController {
        let logInVM = LogInVM(
            credentionalsCollectVM: CredentionalsCollectVM(),
            logInUseCase: StubLogInUseCase(),
            onLogIn: onLogIn
        )
        let logInVC = LogInVC()
        logInVC.viewModel = logInVM
        return logInVC
    }
    
    private func buildConfirmationVC() -> UIViewController {
        let otpVM = OTPConfirmationVM()
        let otpVC = OTPConfirmationVC(viewModel: otpVM)
        return otpVC
    }
}
