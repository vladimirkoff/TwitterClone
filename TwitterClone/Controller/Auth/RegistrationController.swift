//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 01.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePickerController = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let addProfileImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(addProfileImagee), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailViwe: UIView = {
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
    
    private lazy var fullNameView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_mail_outline_white_2x-1")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(fullNameField)
        fullNameField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        
        return view
    }()
    
    private lazy var userNamedView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_lock_outline_white_2x")
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        view.addSubview(UsernameField)
        UsernameField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }()
    
    private let emailField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let UsernameField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Sign in")
        button.addTarget(self, action: #selector(showSignInPage), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Selectors
    
    
    @objc func showSignInPage() {
        let controller = LoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func addProfileImagee() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func signupButtonPressed() {
        guard let profileImage = profileImage else {
            print("Select image")
            return
        }
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        guard let fullName = fullNameField.text else {return}
        guard let userName = UsernameField.text else {return}
        
        
        
       
        
        AuthService.shared.registeruser(parameters: AuthParameters(email: email, password: password, userName: userName, fullName: fullName, profileImage: self.profileImage!)) { error, ref in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("SUCCESSFUL")
        }
        
        
        
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    
   
    //MARK: - Helper
    
    func configureUI() {
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black // changes tint color of time to white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(addProfileImage)
        addProfileImage.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        addProfileImage.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews:[ emailViwe,
                                                   passwordView,
                                                   fullNameView,
                                                   userNamedView,
                                                    signUpButton               ])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: addProfileImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    
        

    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        
        
        
        
        
        
        addProfileImage.layer.cornerRadius = 150 / 2
        addProfileImage.layer.masksToBounds = true
        addProfileImage.imageView?.contentMode = .scaleAspectFill
        addProfileImage.imageView?.clipsToBounds = true
        addProfileImage.layer.borderColor = UIColor.white.cgColor
        addProfileImage.layer.borderWidth = 3
        
        self.addProfileImage.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
