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
    @Binding var isAlertShowing: Bool
    let window: UIWindow
    let title: String
    let action: () -> Void

    var appleLoginButton = UIButton()

    func makeCoordinator() -> Coordinator { Coordinator(self, isAlertShowing: $isAlertShowing) }

    class Coordinator: NSObject {
        var appleLoginButton: AppleLoginButton
        @Binding var isAlertShowing: Bool

        init(_ appleLoginButton: AppleLoginButton, isAlertShowing: Binding<Bool>) {
            self.appleLoginButton = appleLoginButton
            self._isAlertShowing = isAlertShowing
            
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
          
          provider.getCredentialState(forUserID: userID) { [weak self] credentialState, error in
              guard let self else { return }
              
              switch credentialState {
              case .authorized:
                  #if DEBUG
                  print("Apple Login Authorized")
                  #endif
                  
                  guard let identityTokenData = appleIDCredential.identityToken,
                        let identityToken = String(data: identityTokenData, encoding: .utf8) else {
                      return
                  }
                  
                  UIPasteboard.general.string = identityToken // TODO: 테스트 이후 제거 예정
                  self.isAlertShowing = true
              case .notFound, .revoked, .transferred:
                  #if DEBUG
                  print("Apple Login Fail")
                  #endif
                  
                  self.isAlertShowing = true
              @unknown default:
                  self.isAlertShowing = true
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
