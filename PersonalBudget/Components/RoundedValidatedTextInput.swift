//
//  RoundedValidatedTextInput.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import Foundation

import UIKit

class RoundedValidatedTextInput: UIStackView {
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    public var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    public var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 2
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        
        addArrangedSubview(stackView)
    }

   
    
}
