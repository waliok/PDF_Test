//
//  LoginViewController.swift
//  PDF_Test
//
//  Created by Waliok on 11/09/2023.
//

import UIKit
import FirebaseAuthUI
import FirebaseAnonymousAuthUI
import FirebaseGoogleAuthUI

class LoginViewController: UIViewController {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
}

extension LoginViewController {
    
    func setUp() {
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [
            FUIAnonymousAuth(),
            FUIGoogleAuth(authUI: FUIAuth.defaultAuthUI()!)]
        
        let authViewController = FUICustomAuthPickerViewController(authUI: authUI!)
        authViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(authViewController, animated: false)
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        switch error {
        case .some(let error as NSError) where UInt(error.code) == FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in")
        case .some(let error as NSError) where error.userInfo[NSUnderlyingErrorKey] != nil:
            print("Login error: \(error.userInfo[NSUnderlyingErrorKey]!)")
        case .some(let error):
            print("Login error: \(error.localizedDescription)")
        case .none:
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBar())
            print("Login succeeded")
            print("\(String(describing: authDataResult?.user.displayName))")
            
        }
    }
}

//MARK: - Preview

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct LoginViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        
        LoginViewController()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif

