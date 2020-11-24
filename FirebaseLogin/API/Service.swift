//
//  Service.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/23/20.
//

import Foundation
import Firebase
import GoogleSignIn

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)


/// Have a seperate API so we don't have API code in our viewcontroller. Cleaner code

struct Service{
    /// Staic keyword: Think of it as a global variable for this struct ( which is a type ).
    /// We can access this static func directly from the type ( Service.logUserIn() )
    /// instead of having to make an instance and access from there.
    /// As such, all the instances of the type ( Service) would have the same logUserIn function
    
    static func logUserIn(email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    static func registerUserWithFirebase(email: String, password: String, fullname: String, hasSeenOnboardingPage: Bool, completion: @escaping DatabaseCompletion){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error occured during creating user: \(error.localizedDescription)")
                return
            }
            /// To save result in database. First set the unique identifier to the uid created by firebase for user.
            guard let uid = result?.user.uid else {return}
            
            /// create data dictionary / data structure. Don't need to save the pswd.
            let structure = [
                "email": email,
                "fullname": fullname,
                "hasSeenOnboardingPage": hasSeenOnboardingPage
            ] as [String : Any]
            
            REF_USERS.child(uid).updateChildValues(structure, withCompletionBlock: completion)
        }
    }
    
    
    static func signInWithGoogle(didSignInFor user: GIDGoogleUser, completion: @escaping DatabaseCompletion){
        
        guard let auth = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken,
                                                       accessToken: auth.accessToken)
        
        /// normal sign in process but with credential instead of email/pswd
        Auth.auth().signIn(with: credential) { (result, error) in
            
            /// handle error
            if let error = error {
                print("Debug: error when signing in with google credentials, \(error.localizedDescription) ")
                return
            }
            
            /// pull the user's id, email and fullname FROM google credentials
            guard let uid = result?.user.uid else{return}
            guard let email = result?.user.email else{return}
            guard let fullname = result?.user.displayName else{return}

                    
            let structure = [
                "email": email,
                "fullname": fullname,
                "hasSeenOnboardingPage": false
        
            ] as [String: Any]
            
            REF_USERS.child(uid).updateChildValues(structure, withCompletionBlock: completion)
            
        }
    }
    
    
    static func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            print("Debug snapshot Key: \(snapshot.key)")
//            print("Debug snapshot value: \(snapshot.value)")
            
            let uid = snapshot.key
            
            /// cast as dictionary because when fetched from database, its not exactly a dictionary and will not be recogized as one
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            /// make an instance of that user with information pulled from the database
            let user = User(uid: uid, dictionary: dictionary)
            
            /// escape with the user info
            completion(user)
        }
    }
    
    
    static func updateUserHasSeenOnboardingInDatabase(completion: @escaping (DatabaseCompletion)){
        /// find the unique id of the current user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        /// use that current id to access the "hasSeenOnboardingPage" key, then set the value to true.
        /// Once they are all done, execute the completion handler
        REF_USERS.child(uid).child("hasSeenOnboardingPage").setValue(true, withCompletionBlock: completion)
    }
}
