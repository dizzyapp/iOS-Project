//
//  LoginCoordinator.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject

protocol LoginCoordinatorType: NavigationCoordinator {
    var onCoordinatorFinished: () -> Void { get set }

}

final class LoginCoordinator: LoginCoordinatorType, LoginVMNavigationDelegate {
        
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    var navigationController = UINavigationController()
    let presentingVC: UIViewController
    
    var onCoordinatorFinished: () -> Void = { }

    init(container: Container, presentingVC: UIViewController) {
        self.container = container
        self.presentingVC = presentingVC
    }
    
    func start() {
        guard var loginVM = container?.resolve(LoginVMType.self),
            let loginVC = container?.resolve(LoginVC.self, argument: loginVM) else {
                return
        }
        
        loginVM.navigationDelegate = self
//        navigationController = loginVC.embdedInNavigationController().withTransparentStyle()
        loginVC.modalPresentationStyle = .overCurrentContext
        loginVC.view.backgroundColor = .clear
        loginVC.modalPresentationCapturesStatusBarAppearance = true
        presentingVC.present(loginVC, animated: true)
    }
    
    func navigateToHomeScreen() {
        self.presentingVC.dismiss(animated: true, completion: {
            self.onCoordinatorFinished()
        })
    }
    
    func navigateToSignUpScreen() {
        
    }
    
    func navigateToSignInWithDizzyScreen() {
        
    }
    
    func navigateToAboutScreen() {
        
    }
    
    func navigateToTermsOfUseScreen() {
        
    }
    
    func navigateToPrivacyPolicyScreen() {
        
    }
    
    func navigateToContactUsScreen() {
        
    }
    
    func navigateToAdminScreen() {
        
    }
}
