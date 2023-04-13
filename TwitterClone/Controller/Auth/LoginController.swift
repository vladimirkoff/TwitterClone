//
//  LoginController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 01.03.2023.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let logo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_mail_outline_white_2x-1")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(emailField)
        emailField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }()
    
    private lazy var passwordView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_lock_outline_white_2x")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(passwordField)
        passwordField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }()
    
    private let emailField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAnAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign up")
        button.addTarget(self, action: #selector(showSignUpPage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Selectors
    
    @objc func loginButtonPressed() {
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("Error - \(error.localizedDescription)")
            } else {
                AuthService.shared.logUserIn(withEmail: email, withPassword: password) { error, ref in
                    print("Here")
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
                        return
                    }
                    
                    guard let tab = window.rootViewController as? MainTabController
                    else { return }
                    
                    tab.authenticateUser()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            }
        }
        
    }
    
    @objc func showSignUpPage() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logo)
        logo.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        logo.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailView, passwordView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: logo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    }
}
