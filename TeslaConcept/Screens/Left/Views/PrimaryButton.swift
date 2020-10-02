//
//  Button.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 30.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class PrimaryButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = CGFloat(bounds.height / 2)
    }
    
    private func setupUI() {
        backgroundColor = .red
        backgroundColor = UIColor(named: "buttonColor")
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
        
}
