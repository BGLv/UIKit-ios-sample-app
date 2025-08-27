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
        let logInVC = self.buildLoginVC(
            onSignUp: { [weak self] in
                guard let self = self else {return}
                let viewController = self.buildProfileCreationVC(
                    onAlreadyHaveAccount: { [weak self] in
                        self?.navigationController.popViewController(animated: true)
                    },
                    onSuccess: { [weak self] in
                        guard let self = self else {return}
                        self.navigationController.pushViewController(self.buildConfirmationVC(), animated: true)
                    }
                )
                self.navigationController.pushViewController(viewController, animated: true)
            },
            onLogIn: { [weak self] in
            guard let self = self else {return}
            self.navigationController.pushViewController(self.buildConfirmationVC(), animated: true)
        })
        self.navigationController.pushViewController(logInVC, animated: true)
    }
    
    private func buildLoginVC(
        onSignUp: @escaping () -> Void,
        onLogIn: @escaping () -> Void
    ) -> UIViewController {
        let logInVM = LogInVM(
            credentionalsCollectVM: CredentionalsCollectVM(),
            logInUseCase: StubLogInUseCase(),
            onSignUp: onSignUp,
            onLogIn: onLogIn
        )
        let logInVC = LogInVC()
        logInVC.viewModel = logInVM
        return logInVC
    }
    
    private func buildProfileCreationVC(
        onAlreadyHaveAccount: @escaping () -> Void,
        onSuccess: @escaping () -> Void
    ) -> UIViewController {
        let profileCreationVC = ProfileCreationVC()
        let profileCreationVM = ProfileCreationVM(
            profileCollectVM: ProfileCollectVM(),
            createProfileUseCase: StubCreateProfileUseCase(),
            onAlreadyHaveAccount: onAlreadyHaveAccount,
            onSuccess: onSuccess
        )
        profileCreationVC.viewModel = profileCreationVM
        
        return profileCreationVC
    }
    
    private func buildConfirmationVC() -> UIViewController {
        let otpVM = OTPConfirmationVM()
        let otpVC = OTPConfirmationVC(viewModel: otpVM)
        return otpVC
    }
}
