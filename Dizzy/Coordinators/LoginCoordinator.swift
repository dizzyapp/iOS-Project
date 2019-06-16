//
//  LoginCoordinator.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject
import FacebookCore
import FacebookLogin

protocol LoginCoordinatorType: NavigationCoordinator {
    var onCoordinatorFinished: () -> Void { get set }

}

final class LoginCoordinator: LoginCoordinatorType, LoginVMNavigationDelegate, SignUpWithDizzyVMNavigationDelegate, SignInWithDizzyVMNavigationDelegate {
        
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    var navigationController = UINavigationController()
    var presentingVC: UIViewController
    
    var onCoordinatorFinished: () -> Void = { }

    init(container: Container, presentingVC: UIViewController) {
        self.container = container
        self.presentingVC = presentingVC
        navigationController = UINavigationController()
    }
    
    func start() {
        guard var loginVM = container?.resolve(LoginVMType.self),
            let loginVC = container?.resolve(LoginVC.self, argument: loginVM) else {
                return
        }
        
        loginVM.navigationDelegate = self

        let navigationController = loginVC.embdedInNavigationController().withTransparentStyle()
        navigationController.modalPresentationStyle = .overCurrentContext
        self.navigationController = navigationController
        self.presentingVC.present(navigationController, animated: true)
    }
    
    func navigateToHomeScreen() {
        if let discoveryVC = self.presentingVC as? DiscoveryVC {
            discoveryVC.showTopBar()
        }
        self.presentingVC.dismiss(animated: true, completion: {
            self.onCoordinatorFinished()
        })
    }
    
    func navigateToSignUpScreen() {
        guard var viewModel = container?.resolve(SignUpWithDizzyVMType.self),
            let signUpWithDizzyVC = container?.resolve(SignUpWithDizzyVC.self, argument: viewModel) else {
                print("could not create SignUpWithDizzyVC page")
                return
        }
        viewModel.navigationDelegate = self
        navigationController.pushViewController(signUpWithDizzyVC, animated: true)
    }
    
    func navigateToSignInScreen() {
        guard var viewModel = container?.resolve(SignInWithDizzyVMType.self),
            let signInWithDizzyVC = container?.resolve(SignInWithDizzyVC.self, argument: viewModel) else {
                print("could not create SignInWithDizzyVC page")
                return
        }
        viewModel.navigationDelegate = self
        navigationController.pushViewController(signInWithDizzyVC, animated: true)
    }
    
    func navigateToSignInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self.presentingVC) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.navigateToHomeScreen()
            }
        }
    }
    
    func navigateToAppInfoScreen(type: AppInfoType) {
        
    }
    
    func navigateToAdminScreen() {
        
    }
}
