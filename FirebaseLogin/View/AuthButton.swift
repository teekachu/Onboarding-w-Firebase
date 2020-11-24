//
//  customButton.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/20/20.
//

import UIKit

class AuthButton: UIButton {
    var title: String? {
        didSet{
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9137254902, blue: 0.8039215686, alpha: 1).withAlphaComponent(0.5)
        setTitleColor(#colorLiteral(red: 0.4666666667, green: 0.6745098039, blue: 0.6352941176, alpha: 1) , for: .normal)
        setHeight(height: 50)
        /// require form validation to enable
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    convenience init(title: String){
    //        self.init(frame: .zero)
    //
    //        setTitle(title, for: .normal)
    //    }
    
}

