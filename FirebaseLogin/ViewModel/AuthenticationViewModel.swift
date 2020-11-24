//
//  AuthenticationViewModel.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/21/20.
//

/// Use ViewModel when logic is involved surrounding updating the UI based on certain circumstances.
/// As it handles background process, and takes weight off the main VC.

import UIKit

/// Since there are repeated code, consider putting it in  a protocol,
/// As the structs all conform to the same protocol, it will enforce to have certain functions.

protocol AuthenticationViewModel{
    /// get means read only
    var formIsValid: Bool {get}
    var shouldEnableButton: Bool {get}
    var buttonTitleColor: UIColor {get}
    var buttonBackgroundColor: UIColor {get}
    
}

protocol FormViewModel {
    func updateForm()
}

struct LoginViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
    
    var shouldEnableButton: Bool{
        return formIsValid
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.2745098039, green: 0.5058823529, blue: 0.537254902, alpha: 1) : #colorLiteral(red: 0.4666666667, green: 0.6745098039, blue: 0.6352941176, alpha: 1)
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1) : #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1).withAlphaComponent(0.5)
    }
    
}

struct RegistrationViewModel: AuthenticationViewModel{
    
    var email: String?
    var password: String?
    var fullname: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? #colorLiteral(red: 0.2745098039, green: 0.5058823529, blue: 0.537254902, alpha: 1) : #colorLiteral(red: 0.4666666667, green: 0.6745098039, blue: 0.6352941176, alpha: 1)
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1) : #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1).withAlphaComponent(0.5)
    }
    
    
}

struct ResetPasswordViewModel: AuthenticationViewModel{
    
    var email: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? #colorLiteral(red: 0.2745098039, green: 0.5058823529, blue: 0.537254902, alpha: 1) : #colorLiteral(red: 0.4666666667, green: 0.6745098039, blue: 0.6352941176, alpha: 1)
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1) : #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1).withAlphaComponent(0.5)
    }
    
    
}
