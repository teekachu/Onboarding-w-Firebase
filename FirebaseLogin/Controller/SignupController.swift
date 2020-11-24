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
        
        
        /// create user
        Service.registerUserWithFirebase(email: emailtf, password: passwordtf, fullname: fullnametf, hasSeenOnboardingPage: false) { (error, ref) in
            
            /// Save in database
            if let error = error {
                print("DEBUG: Error occured during storing user info in database: \(error.localizedDescription)")
                return
            }
            
            /// success
            print("Debug: Successfully reated user and updated userinfo")
            self.dismiss(animated: true, completion: nil)
            
        }

        
        //        Auth.auth().createUser(withEmail: emailtf, password: passwordtf) { (result, error) in
        //            if let error = error {
        //                print("DEBUG: Error occured during creating user: \(error.localizedDescription)")
        //                return
        //            }
        //            /// To save result in database. First set the unique identifier to the uid created by firebase for user.
        //            guard let uid = result?.user.uid else {return}
        //
        //            /// create data dictionary / data structure. Don't need to save the pswd.
        //            let structure = [
        //                "email": emailtf,
        //                "fullname": fullnametf
        //            ]
        //
        //            /// Save in database
        //            Database.database().reference().child("Users").child(uid).updateChildValues(structure) { (error, ref) in
        //
        //                if let error = error {
        //                    print("DEBUG: Error occured during storing user info in database: \(error.localizedDescription)")
        //                    return
        //                }
        //
        //                /// success
        //                print("Created user and updated userinfo")
        //            }
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
