//
//  LoginViewController.swift
//  Whatsgram
//
//  Created by Trung on 17/04/2023.
//

import Foundation
import UIKit
import FirebaseAuth
import JGProgressHUD
class LoginViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.clipsToBounds = true
    return scrollView
}()

private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "icon")
    imageView.contentMode = .scaleAspectFit
    return imageView
}()
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
    field.backgroundColor = .white
    return field
}()
private let passwordField: UITextField={
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.returnKeyType = .done
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.placeholder = "Password"
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    field.leftViewMode = .always
    field.backgroundColor = .white
    field.isSecureTextEntry = true
    return field
}()
private let loginButton : UIButton={
    let button = UIButton()
    button.setTitle("Log in", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .link
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 20,weight: .bold)
    return button
}()
override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
        
    view.backgroundColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self , action: #selector(didTapLogin))
    // Do any additional setup after loading the view.
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: . touchUpInside)
    emailField.delegate = self
    passwordField.delegate = self
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.addSubview(emailField)
    scrollView.addSubview(passwordField)
    scrollView.addSubview(loginButton)
}
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.frame = view.bounds
    let size = scrollView.width/3
    imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
    emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 52)
    passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 52)
    loginButton.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width - 60, height: 52)
}
@objc private func loginButtonTapped(){
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    guard let email = emailField.text,
          let password = passwordField.text,!email.isEmpty,!password.isEmpty, password.count >= 6
    else{
        alerUserLoginError()
        return
    }
    spinner.show(in: view)
    //Firebase Login
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,completion: {[weak self] authResult, error in
        
        guard let strongSelf = self else{
            return
        }
        DispatchQueue.main.async {
            strongSelf.spinner.dismiss(animated: true)
        }
        guard let result = authResult, error == nil else{
            print("Failed to log in user with email: \(email)")
            return
        }
        let user = result.user
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getDataFor(path: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let data):
                guard let userData = data as? [String: Any],
                        let firstName = userData["first name"] as? String,
                        let lastName = userData["last_name"] as? String
            else{
                print("Failed to get the name")
                return
            }
                UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
            case .failure(let error):
                print ("Failed to read data with error \(error)")
            }
        })
        
       
        UserDefaults.standard.set(email, forKey: "email")
        
        print("Logged in user : \(user)")
        strongSelf.navigationController?.dismiss(animated: true,completion: nil)
    })}
func alerUserLoginError(){
    let alert = UIAlertController(title: "Woops", message: "Please enter all information to login ", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
    present(alert, animated: true)
    
}
@objc private func didTapLogin(){
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
}

}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            loginButtonTapped()
        }
        return true
    }
}

