//
//  LoginController.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/20/20.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var viewmodel = LoginViewModel()
    
    private let logoImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private let emailTextField = CustomTextfield(for: "email")
    
    private let passwordTextfield: UITextField = {
        let tf = CustomTextfield(for: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private var stackview = UIStackView()
    private var secondStackView = UIStackView()
    
    private let loginButton: AuthButton = {
        let authButton = AuthButton(type: .system)
        authButton.title = "Log In"
        authButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return authButton
    }()
    
    private var forgotPasswordButton: UIButton = {
        let button = customAttributesButton(stringLeft: "Forgot your password?", stringRight: "Get help signing in.")
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let dividerView = DividerView()
    
    private var googleLoginButton: UIButton {
        let button = UIButton(type: .system)
        /// always original means the image will always keep its original color.
        button.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Login with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }
    
    private var signUpButton: UIButton = {
        
        let button = customAttributesButton(
            stringLeft: "Don't have an account?",
            stringRight: "Sign up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// configure UI
        configureUI()
        configureImage()
        configureStackView()
        configureSecondStack()
        configureSignup()
        
        /// configure view model
        notificationObservers()
        
        /// configure google sign in abilities
        configureGoogleLogIn()
    }
    
    // MARK: Selectors
    @objc func handleLogin(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextfield.text else{return}
        
        Service.logUserIn(email: email, password: password) {[weak self] (result, error) in
            if let error = error{
                print("Debug: error signing in, \(error.localizedDescription)")
                return
            }
            print("Debug: success logging in")
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleForgotPassword(){
        let rvc = ResetPasswordViewController()
        navigationController?.pushViewController(rvc, animated: true)
    }
    
    @objc func handleGoogleLogin(){
        /// action handler
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleSignUp(){
        let vc = SignupController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField){
        if sender == emailTextField{
            viewmodel.email = emailTextField.text
        } else {
            viewmodel.password = passwordTextfield.text
        }
        //        print("Debug: \(viewmodel.shouldEnableButton) ")
        
        updateForm()
    }
    
    // MARK: - Helper
    
    func notificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
    
    private  func configureStackView(){
        stackview = UIStackView(arrangedSubviews: [
                                    emailTextField, passwordTextfield, loginButton])
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
    
    private func configureSecondStack(){
        secondStackView = UIStackView(arrangedSubviews: [
                                        forgotPasswordButton, dividerView, googleLoginButton])
        secondStackView.axis = .vertical
        secondStackView.spacing = 28
        view.addSubview(secondStackView)
        secondStackView.anchor(
            top: stackview.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 24,
            paddingLeft: 32,
            paddingRight: 32)
    }
    
    private func configureSignup(){
        view.addSubview(signUpButton)
        signUpButton.centerX(inView: view)
        signUpButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureGoogleLogIn(){
        /// When GIDSignIn is called, show the viewcontroller for google signin
        GIDSignIn.sharedInstance()?.presentingViewController = self
        /// and make the viewcontroller the delegate for google signin
        GIDSignIn.sharedInstance()?.delegate = self
    }
}

// MARK: extension
extension LoginController: FormViewModel {
    
    func updateForm(){
        loginButton.isEnabled = viewmodel.shouldEnableButton
        loginButton.backgroundColor = viewmodel.buttonBackgroundColor
        loginButton.setTitleColor(viewmodel.buttonTitleColor, for: .normal)
    }
}

extension LoginController: GIDSignInDelegate{
    
    /// this gets called after user input their google account information into auth.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        Service.signInWithGoogle(didSignInFor: user) {[weak self] (error, ref) in
            if let error = error {
                print("Debug: error during google credential sign in. \(error.localizedDescription)")
            }
            
            print("Debug: successfully handled google sign in ")
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
