//
//  SignupController.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/21/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupController : UIViewController {
    
    // MARK: - Properties
    
    /// Protocol is initialized in LoginController, so do not need to recreate another protocol.
    weak var delegate: AuthenticationDelegate?
    
    private var viewmodel = RegistrationViewModel()
    
    private let logoImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private var stackview = UIStackView()
    
    private let emailTextField = CustomTextfield(for: "email")
    
    private let passwordTextfield: UITextField = {
        let tf = CustomTextfield(for: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextfield = CustomTextfield(for: "fullname")
    
    private var signUpButton: AuthButton = {
        let authButton = AuthButton(type: .system)
        authButton.title = "Sign Up"
        authButton.addTarget(self, action: #selector(confirmSignUp), for: .touchUpInside)
        return authButton
    }()
    
    private var loginButton: UIButton = {
        let button = customAttributesButton(stringLeft: "Already have an account?", stringRight: "Log In")
        button.addTarget(self, action: #selector(goBacktoLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureImage()
        configureStackView()
        configureLogin()
        
        /// configure view model
        notificationObservers()
    }
    
    // MARK: Selectors
    @objc func confirmSignUp(){
        
        guard let emailtf = emailTextField.text else {return}
        guard let passwordtf = passwordTextfield.text else {return}
        guard let fullnametf = fullnameTextfield.text else {return}
        
        showLoader(true)
        
        /// create user in Realtime database
        Service.registerUserWithFirebase(email: emailtf, password: passwordtf, fullname: fullnametf, hasSeenOnboardingPage: false) {[weak self] (error, ref) in
            
            self?.showLoader(false)
            
            /// Save in database
            if let error = error {
                self?.showMessage(withTitle: "Error", message: error.localizedDescription)
                //                print("DEBUG: Error occured during storing user info in database: \(error.localizedDescription)")
                return
            }
            
            /// success
            print("Debug: Successfully reated user and updated userinfo")
            
            /// After successfully logging in, we want to conform to the protocol of  AuthenticationDelegate
            /// And basically fetch the new user's information
            self?.delegate?.authenticationComplete()
            
            //            self.dismiss(animated: true, completion: nil)
        }
        
        /// create user in Firestore
        //        Service.registerUserWithFirestore(email: emailtf, password: passwordtf, fullname: fullnametf, hasSeenOnboardingPage: false) {[weak self] (error) in
        //            if let error = error {
        //                self?.showMessage(withTitle: "Error.", message: error.localizedDescription)
        //                return
        //            }
        //
        //            self?.delegate?.authenticationComplete()
        //
        //        }
    }
    
    @objc func goBacktoLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField){
        if sender == emailTextField{
            viewmodel.email = emailTextField.text
        } else if sender == passwordTextfield {
            viewmodel.password = passwordTextfield.text
        } else {
            viewmodel.fullname = fullnameTextfield.text
        }
        //        print("Debug: \(viewmodel.shouldEnableButton) ")
        
        updateForm()
    }
    
    // MARK: Helpers
    
    func notificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: Privates
    private func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientBackground()
    }
    
    private func configureImage(){
        
        view.addSubview(logoImage)
        logoImage.centerX(inView: view)
        logoImage.setDimensions(height: 120, width: 120)
        logoImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 32)
    }
    
    private func configureStackView(){
        stackview = UIStackView(arrangedSubviews: [
                                    emailTextField, passwordTextfield, fullnameTextfield, signUpButton])
        stackview.axis = .vertical
        stackview.spacing = 20
        view.addSubview(stackview)
        stackview.anchor(
            top: logoImage.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32)
    }
    
    private func configureLogin(){
        view.addSubview(loginButton)
        loginButton.centerX(inView: view)
        loginButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
}

// MARK: Extension
extension SignupController: FormViewModel{
    
    func updateForm(){
        signUpButton.isEnabled = viewmodel.shouldEnableButton
        signUpButton.backgroundColor = viewmodel.buttonBackgroundColor
        signUpButton.setTitleColor(viewmodel.buttonTitleColor, for: .normal)
    }
}
