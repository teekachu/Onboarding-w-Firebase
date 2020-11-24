//
//  DividerView.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/20/20.
//

import UIKit

class DividerView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor(white: 1, alpha: 0.87)
        label.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(label)
        label.centerX(inView: self)
        label.centerY(inView: self)
        
        let dividerOne = UIView()
        dividerOne.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(dividerOne)
        dividerOne.centerY(inView: self)
        dividerOne.anchor(left: self.leftAnchor, right: label.leftAnchor,
                          paddingLeft: 8, paddingRight: 8, height: 1)
        
        let dividerTwo = UIView()
        dividerTwo.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(dividerTwo)
        dividerTwo.centerY(inView: self)
        dividerTwo.anchor(left: label.rightAnchor, right: self.rightAnchor,
                          paddingLeft: 8, paddingRight: 8, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

