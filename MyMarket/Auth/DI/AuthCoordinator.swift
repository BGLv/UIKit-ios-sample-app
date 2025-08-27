//
//  AuthCoordinator.swift
//  MyMarket
//
//  Created by Bohdan Huk on 25.08.2025.
//
import UIKit

class AuthCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public
    
    func start() {
        let logInVC = self.buildLoginVC(
            onSignUp: { [weak self] in self?.showProfileCreation() },
            onLogIn: { [weak self] in self?.showConfirmation() }
        )
        navigationController.setViewControllers([logInVC], animated: false)
    }
    
    // MARK: - Navigation
    
    private func showProfileCreation() {
        let vc = buildProfileCreationVC(
            onAlreadyHaveAccount: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            },
            onSuccess: { [weak self] in
                self?.showConfirmation()
            }
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showConfirmation() {
        let vc = buildConfirmationVC()
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Builders
    
    private func buildLoginVC(
        onSignUp: @escaping () -> Void,
        onLogIn: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = LogInVM(
            credentionalsCollectVM: CredentionalsCollectVM(),
            logInUseCase: StubLogInUseCase(),
            onSignUp: onSignUp,
            onLogIn: onLogIn
        )
        let viewController = LogInVC()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func buildProfileCreationVC(
        onAlreadyHaveAccount: @escaping () -> Void,
        onSuccess: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = ProfileCreationVM(
            profileCollectVM: ProfileCollectVM(),
            createProfileUseCase: StubCreateProfileUseCase(),
            onAlreadyHaveAccount: onAlreadyHaveAccount,
            onSuccess: onSuccess
        )
        let viewController = ProfileCreationVC()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func buildConfirmationVC() -> UIViewController {
        let viewModel = OTPConfirmationVM(
            onGoBack: {[weak self] in self?.navigationController.popViewController(animated: true)}
        )
        let viewController = OTPConfirmationVC(viewModel: viewModel)
        return viewController
    }
}
