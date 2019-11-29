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

final class LoginCoordinator: LoginCoordinatorType {
    
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    var navigationController = UINavigationController()
    var presentingVC: UIViewController
    let allPlaces: [PlaceInfo]
    
    var onCoordinatorFinished: () -> Void = { }

    init(container: Container, presentingVC: UIViewController, allPlaces: [PlaceInfo]) {
        self.container = container
        self.presentingVC = presentingVC
        navigationController = UINavigationController()
        self.allPlaces = allPlaces
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
        navigationController.modalPresentationStyle = .fullScreen
        self.presentingVC.present(navigationController, animated: true)
    }
   
}

extension LoginCoordinator: LoginVMNavigationDelegate, SignInWithDizzyVMNavigationDelegate, SignUpWithDizzyVMNavigationDelegate {
    func userLoggedOut() {
        container?.autoregister(DizzyUser.self, initializer: {
            return DizzyUser.guestUser()
        })
    }
    
    func userLoggedIn(user: DizzyUser) {
        container?.autoregister(DizzyUser.self, initializer: {
            return user
        })
        closePressed()
    }
    
    func closePressed() {
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
    
    func navigateToAppInfoScreen(type: AppInfoType) {
        var baseUrl = "https://dizzy.co.il/"
        switch type {
            case .about:
                baseUrl += ""
            case .contactUs:
                baseUrl += ""
            case .privacyPolicy:
                baseUrl += ""
            case .termsOfUse:
                baseUrl += ""
        }
        if let url = URL(string: baseUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(baseUrl): \(success)")
                })
        }
    }
    
    func navigateToAdminScreen(with user: DizzyUser) {
        guard let adminSettingsCoordinator = container?.resolve(AdminSettingsCoordinatorType.self, argument: navigationController) else {
            print("could not create adminSettingsCoordinator page")
            return
        }
        
        adminSettingsCoordinator.onAdminSettingsCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .adminSettings)
        }
        
        adminSettingsCoordinator.start()
        add(coordinator: adminSettingsCoordinator, for: .adminSettings)
    }
}
