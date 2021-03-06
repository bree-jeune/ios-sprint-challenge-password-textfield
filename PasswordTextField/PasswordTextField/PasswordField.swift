//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

@IBDesignable

class PasswordField: UIControl {
    
    enum PasswordStrength: String {
        case weak = "Too Weak"
        case medium = "Could Be Stronger"
        case strong = "Strong Password"
    }
    
    var passwordStrength: PasswordStrength = .weak
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textField.delegate = self
        setup()
    }
    
    func setup() {
        
        self.backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.textColor = labelTextColor
        titleLabel.font = labelFont

        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: standardMargin), titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: standardMargin), titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: standardMargin)])
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame.size.height = textFieldContainerHeight
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4

        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = true
        textField.font = labelFont
        textField.text = ""
        textField.becomeFirstResponder()

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldMargin),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        ])
        

            addSubview(showHideButton)
            showHideButton.frame = CGRect(x: 330, y: 44, width: 30, height: 30)
            showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
            showHideButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)


            addSubview(weakView)
            weakView.backgroundColor = weakColor
            weakView.frame = CGRect(x: standardMargin, y: 97, width: colorViewSize.width, height: colorViewSize.height)

            addSubview(mediumView)
            mediumView.backgroundColor = unusedColor
            mediumView.frame = CGRect(x: standardMargin * 2 + colorViewSize.width, y: 97, width: colorViewSize.width, height: colorViewSize.height)

            addSubview(strongView)
            strongView.backgroundColor = unusedColor
            strongView.frame = CGRect(x: standardMargin * 3 + colorViewSize.width * 2, y: 97, width: colorViewSize.width, height: colorViewSize.height)
        
        addSubview(strengthDescriptionLabel)
            strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                strengthDescriptionLabel.centerYAnchor.constraint(equalTo: strongView.centerYAnchor),
                strengthDescriptionLabel.leadingAnchor.constraint(equalTo: strongView.trailingAnchor, constant: 10),
                strengthDescriptionLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
            ])
            strengthDescriptionLabel.text = "Too Weak"
            strengthDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
            strengthDescriptionLabel.textColor = labelTextColor
            strengthDescriptionLabel.textAlignment = .left

        }

        @objc func buttonTapped() {
            if textField.isSecureTextEntry == true {
                textField.isSecureTextEntry = false
                showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
            } else {
                textField.isSecureTextEntry = true
                showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
            }
    }
    
}

extension PasswordField: UITextFieldDelegate {
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)

    // TODO: send new text to the determine strength method
    password = newText
    switch password.count {
    case 0...7:
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        strengthDescriptionLabel.text = "Weak"
        passwordStrength = .weak

        UIView.animate(withDuration: 0.3, animations: {
            self.weakView.transform = CGAffineTransform(scaleX: 1.1, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.weakView.transform = .identity
            }
        }
    case 8...14:
        mediumView.backgroundColor = mediumColor
        strongView.backgroundColor = unusedColor
        strengthDescriptionLabel.text = "Could be stronger"
        passwordStrength = .medium

        UIView.animate(withDuration: 0.3, animations: {
            self.mediumView.transform = CGAffineTransform(scaleX: 1.1, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.mediumView.transform = .identity
            }
        }
    case 15...:
        mediumView.backgroundColor = mediumColor
        strongView.backgroundColor = strongColor
        strengthDescriptionLabel.text = "Strong password"
        passwordStrength = .strong

        UIView.animate(withDuration: 0.3, animations: {
            self.strongView.transform = CGAffineTransform(scaleX: 1.1, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.strongView.transform = .identity
            }
        }
    default:
        weakView.backgroundColor = unusedColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        strengthDescriptionLabel.text = "Invalid Password"
    }
    return true
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()

    // send password and strength level to ViewController
    sendActions(for: .valueChanged)
    return true
}
}

