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

import ComposableArchitecture

struct AppleLoginButton: UIViewRepresentable {
    let viewStore: ViewStore<LoginStore.State, LoginStore.Action>
    let window: UIWindow
    let title: String
    let action: (String) -> Void

    var appleLoginButton = UIButton()

    func makeCoordinator() -> Coordinator { Coordinator(self, viewStore: viewStore) }

    class Coordinator: NSObject {
        var appleLoginButton: AppleLoginButton
        let viewStore: ViewStore<LoginStore.State, LoginStore.Action>
        
        init(_ appleLoginButton: AppleLoginButton, viewStore: ViewStore<LoginStore.State, LoginStore.Action>) {
            self.appleLoginButton = appleLoginButton
            self.viewStore = viewStore
            
            super.init()
        }

        @objc func doAction(_ sender: Any) {
            requestAppleLogin()
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
        container.foregroundColor = .white
        
        configuration.attributedTitle = AttributedString(self.title, attributes: container)
        configuration.image = UIImage(named: "apple_logo_medium")
        configuration.imagePadding = 95
        configuration.contentInsets.trailing = 113
        configuration.background.backgroundColor = .black
        
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
          let userName = appleIDCredential.fullName?.formatted() // TODO: 필요없는 경우 제거
          
          provider.getCredentialState(forUserID: userID) { [weak self] credentialState, _ in
              guard let self else { return }
              
              switch credentialState {
              case .authorized:
                  #if DEBUG
                  print("Apple Login Authorized")
                  #endif
                  
                  let userIdentity = appleIDCredential.user
                  self.appleLoginButton.action(userIdentity)
              case .notFound, .revoked, .transferred:
                  #if DEBUG
                  print("Apple Login Fail")
                  #endif
                  
                  self.viewStore.send(.showAlert)
              @unknown default:
                  self.viewStore.send(.showAlert)
              }
          }
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
