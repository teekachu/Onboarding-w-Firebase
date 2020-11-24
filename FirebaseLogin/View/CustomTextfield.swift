//
//  customTextfield.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/20/20.
//

import Foundation
import UIKit

class CustomTextfield: UITextField {
    init(for placeholderText: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor  = UIColor(white: 1, alpha: 0.1)
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholderText.uppercased(),
                                                      attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        /// create spacer manually, set leftview and leftviewMode
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
