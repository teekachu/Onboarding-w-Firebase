//
//  ForgotPasswordButton.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/20/20.
//

import UIKit

class customAttributesButton: UIButton {
    
    init(stringLeft: String, stringRight: String){
        super.init(frame: .zero)
        
        let atts: [NSAttributedString.Key: Any] =
            [.foregroundColor: UIColor(white: 1, alpha: 0.67),
             .font: UIFont.systemFont(ofSize: 15)]
        let attributedTitle = NSMutableAttributedString(
            string: "\(stringLeft) ",attributes: atts)
        
        let boldAtts:[NSAttributedString.Key: Any] =
            [.foregroundColor: UIColor(white: 1, alpha: 0.67),
             .font: UIFont.boldSystemFont(ofSize: 15)]
        let boldTitle = NSMutableAttributedString(
            string: stringRight, attributes: boldAtts)
        
        /// add second half to first half
        attributedTitle.append(boldTitle)
        
        self.setAttributedTitle(attributedTitle, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
