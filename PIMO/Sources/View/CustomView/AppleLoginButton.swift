//
//  AppleLoginButton.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/09.
//  Copyright © 2023 pimo. All rights reserved.
//

import AuthenticationServices
import SwiftUI
import UIKit

struct AppleLoginButton: UIViewRepresentable {
    let window: UIWindow
    let title: String
    let action: () -> Void

    var appleLoginButton = UIButton()
    
    init(window: UIWindow, title: String, action: @escaping () -> Void) {
        self.window = window
        self.title = title
        self.action = action
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        var appleLoginButton: AppleLoginButton

        init(_ appleLoginButton: AppleLoginButton) {
            self.appleLoginButton = appleLoginButton
            
            super.init()
        }

        @objc func doAction(_ sender: Any) {
            requestAppleLogin()
            self.appleLoginButton.action()
        }
        
        private func requestAppleLogin() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self

            controller.performRequests()
        }
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = .systemFont(ofSize: 18)
        
        configuration.attributedTitle = AttributedString(self.title, attributes: container)
        configuration.image = UIImage(named: "apple_logo_medium")
        configuration.imagePadding = 95
        configuration.contentInsets.trailing = 113
        
        button.tintColor = .black
        button.configuration = configuration
        
        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)
        
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) { }
}

extension AppleLoginButton.Coordinator: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
      switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
          let userID = appleIDCredential.user
          let provider = ASAuthorizationAppleIDProvider()
          let userName = appleIDCredential.fullName?.formatted()
          
          print(userID)
      default:
        break
      }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      
    }
}

extension AppleLoginButton.Coordinator: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return appleLoginButton.window
    }
}
