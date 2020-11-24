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
            print("Debug: seen onboarding screen: \(String(describing: user?.hasSeenOnboardingPage))")
            presentOnboardingIfNecessary()
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatedUser()
        configureUI()
        
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
    
    func fetchUser(){
        Service.fetchUser { (user) in
//            print("Debug: fetch did complete")
//            print("Debug: user is \(user.fullname)")
//            print("Debug: user has seen onboarding: \(user.hasSeenOnboardingPage)")
            
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
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    fileprivate func presentLoginVC() {
        DispatchQueue.main.async {[weak self] in
            let controller = LoginController()
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
            
//            if shouldShowOnboarding{
//                presentOnboardingViewController()
//            }
        }
    }
}

/// 4) Conform to that delegate by creating an extension
extension HomeViewController: OnboardingControllerDelegate {
    func controllerWantsToDismiss(_ controller: OnboardingController) {
        dismiss(animated: true)
        
        /// After the onboarding controller dismiss,  update the value in databse.
        Service.updateUserHasSeenOnboardingInDatabase { (error, ref) in
            if let error = error {
                print("Debug: error during updating the user's hasSeenOnboarding property, \(error.localizedDescription)")
            }
            
            self.user?.hasSeenOnboardingPage = true
        }

    }
}
