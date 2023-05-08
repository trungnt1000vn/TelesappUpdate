//
//  ForgotPasswordViewController.swift
//  Telesapp
//
//  Created by Trung on 06/05/2023.
//

import UIKit
import FirebaseAuth
class ForgotPasswordViewController: UIViewController {
    private let emailField: UITextField={
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address"
        field.keyboardType = UIKeyboardType.emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    private let sendEmailButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send Email", for: .normal)
        button.setTitleColor(.secondarySystemBackground, for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
        return button
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Reset Password"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(emailField)
        view.addSubview(sendEmailButton)
        view.addSubview(titleLabel)
        
        sendEmailButton.addTarget(self, action: #selector(sendButtonTapped), for: . touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        emailField.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        sendEmailButton.frame = CGRect(x: 95, y: emailField.bottom + 10, width: 210, height: 52)
        titleLabel.frame = CGRect(x: 110, y: emailField.top - 100, width: 300, height: 100)
    }
    @objc private func sendButtonTapped(){
        Auth.auth().sendPasswordReset(withEmail: emailField.text!, completion: {
            error in
            if let error = error {
                let alert = UIAlertController(title: "Failed to send", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let alertOK = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                let alertCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: {acting in
                    self.emailField.text = ""
                })
                alert.addAction(alertOK)
                alert.addAction(alertCancel)
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Success", message: "An email has been sent, please check it !!!", preferredStyle: .actionSheet)
                let alertOK = UIAlertAction(title: "OKe", style: .default, handler: nil)
                alert.addAction(alertOK)
                self.present(alert, animated: true)
            }
        })
    }
}
