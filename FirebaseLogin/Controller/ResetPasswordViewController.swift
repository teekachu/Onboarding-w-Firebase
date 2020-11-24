//
//  ResetPasswordViewController.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/21/20.
//

import UIKit

protocol ResetPasswordViewControllerDelegate: class{
    func didSendResetPasswordLink()
}

class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ResetPasswordViewControllerDelegate?
    
    private var viewModel = ResetPasswordViewModel()
    
    private let logoImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private var stackview = UIStackView()
    
    private var emailTextField = CustomTextfield(for: "email")
    
    var email: String?
    
    private var resetLinkButton: AuthButton = {
        let authButton = AuthButton(type: .system)
        authButton.title = "Send Reset Link"
        authButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        return authButton
    }()
    
    private var loginButton: UIButton = {
        let button = customAttributesButton(stringLeft: "Want to try Login again?", stringRight: "Go back")
        button.addTarget(self, action: #selector(didTapToReturn), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureImage()
        configureStackView()
        configureLogin()
        loadEmail()
        
        /// configure view model
        notificationObservers()
    }
    
    
    // MARK: Selectors
    @objc func handleResetButton(){
//        print("Debug: handle reset Link")
        showLoader(true)
        guard let email = viewModel.email else{return}
        
        Service.resetPassword(for: email) {[weak self] (error) in
            
            if let error = error{
//                print("DEBUG: Failed to handle reset password, \(error.localizedDescription)")
                self?.showMessage(withTitle: "Error", message: error.localizedDescription)
                self?.showLoader(false)
                return
            }
            /// go back to the login page with some messages saying the email has been sent for user feedback
            
            self?.showLoader(false)
            self?.delegate?.didSendResetPasswordLink()
        }
        
    }
    
    @objc func didTapToReturn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField){
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        }
        
        updateForm()
    }
    
    // MARK: Helpers
    
    func notificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: Privates
    func configureUI(){
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
                                    emailTextField, resetLinkButton])
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
    
    private func loadEmail(){
        guard let email = email else {return}
        emailTextField.text = email /// copy over the email from loginVC to this VC
        viewModel.email = email /// logic for updating the active button based on viewModel
        updateForm() /// actually activate the button
    }
    
}

// MARK: Extension
extension ResetPasswordViewController: FormViewModel{
    
    func updateForm(){
        resetLinkButton.isEnabled = viewModel.shouldEnableButton
        resetLinkButton.backgroundColor = viewModel.buttonBackgroundColor
        resetLinkButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}
