//
//  HomeViewController.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/23/20.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    // MARK: Properties
    /// Because when the VC is first initialized, it will not have a value,
    /// Also if the user is new, there will not be an value
    private var user: User? {
        didSet{
            /// Only when this property gets set, then we want to do some stuff.
            //            print("Debug: seen onboarding screen: \(String(describing: user?.hasSeenOnboardingPage))")
            
            presentOnboardingIfNecessary()
            showWelcomeLabel()
        }
    }
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatedUser()
        configureUI()
        configureWelcomeLabel()
    }
    
    // MARK: Selectors
    @objc func didTapLogOut(){
        let ac = UIAlertController(title: "Are you sure you want to sign out ?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {[weak self] _ in
            self?.logout()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: API
    /// It's cleaner to keep logout with API section and then call that in Selectors.
    func logout(){
        do{
            try Auth.auth().signOut()
            presentLoginVC()
        }catch{
            print("Debug: Error during sign out")
        }
    }
    
    /// Fetch from realtime database
    func fetchUser(){
        Service.fetchUser { (user) in
            //            print("Debug: fetch did complete")
            //            print("Debug: user is \(user.fullname)")
            //            print("Debug: user has seen onboarding: \(user.hasSeenOnboardingPage)")
            
            self.user = user
        }
    }
    
    /// Fetch from Firestore
    func fetchUserFromFirestore(){
        Service.fetchUserFromFirestore { (user) in
            self.user = user
        }
    }
    
    // MARK: Privates
    
    func configureUI() {
        configureGradientBackground()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Welcome"
        
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapLogOut))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    func configureWelcomeLabel(){
        view.addSubview(welcomeLabel)
        welcomeLabel.centerX(inView: view)
        welcomeLabel.centerY(inView: view)
        welcomeLabel.anchor(width: UIScreen.main.bounds.width * 0.8, height: 300)
    }
    
    fileprivate func presentLoginVC() {
        DispatchQueue.main.async {[weak self] in
            let controller = LoginController()
            /// set delegate as self for the AuthenticationDelegate
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }
    }
    
    fileprivate func presentOnboardingIfNecessary() {
        /// make sure user exist
        guard let user = user else {return}
        
        /// make sure user has not seen onboarding
        guard !user.hasSeenOnboardingPage else {return}
        
        /// show onboarding stuff
        let controller = OnboardingController()
        /// Set the onboardingController's delegate to self, so the homeview will be the one passing information around
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    private func authenticatedUser(){
        /// Check which screen to show. if the current user's uid is nil,
        /// then the user has been logged out, show login screen,
        /// otherwise show home screen
        
        if Auth.auth().currentUser?.uid == nil{
            presentLoginVC()
        } else {
            
            //            print("Debug: user is logged in")
            /// When in homescreen. Also fetch this user's information,
            /// so we know if the user has seen onboarding page before or not.
            /// If not, show onboardingVC, otherwise do nothing.
            
            fetchUser()
            //            fetchUserFromFirestore()
        }
    }
    
    private func showWelcomeLabel(){
        guard let user = user else {return}
        guard user.hasSeenOnboardingPage else {return}
        
        welcomeLabel.text = "Good to see you again,\n\(user.fullname)"
        welcomeLabel.numberOfLines = 3
        welcomeLabel.textAlignment = .center
        UIView.animate(withDuration: 1) {
            self.welcomeLabel.alpha = 1
        }
    }
}


// MARK: Extension
/// 4) Conform to that delegate by creating an extension
extension HomeViewController: OnboardingControllerDelegate {
    func controllerWantsToDismiss(_ controller: OnboardingController) {
        dismiss(animated: true)
        
        /// After the onboarding controller dismiss,  update the value in databse.
        Service.updateUserHasSeenOnboardingInDatabase {[weak self] (error, ref) in
            if let error = error {
                self?.showMessage(withTitle: "Error", message: error.localizedDescription)
                print("Debug: error during updating the user's hasSeenOnboarding property, \(error.localizedDescription)")
            }
            self?.user?.hasSeenOnboardingPage = true
        }
        
        /// After the onboarding controller dismiss,  update the value in firestore.
        //        Service.updateUserHasSeenOnboardingInFirestore {[weak self] (error) in
        //            if let error = error {
        //                self?.showMessage(withTitle: "Error", message: error.localizedDescription)
        //            }
        //
        //            self?.user?.hasSeenOnboardingPage = true
        //        }
    }
}

extension HomeViewController: AuthenticationDelegate {
    /// In Login and sign up page, we have a delegate that is going to call this function after the user is logged / signed in.
    /// The homeVC needs to conform to the delegate because we are the one that needs to receive information from those pages of the new user info.
    
    func authenticationComplete() {
        /// first dismiss whatever VC it was , either login or sign in
        dismiss(animated: true, completion: nil)
        
        /// fetch the current user
        fetchUser()
        //        fetchUserFromFirestore()
    }
    
    
}
