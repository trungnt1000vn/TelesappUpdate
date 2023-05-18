//
//  ProfilerViewController.swift
//  Telesapp
//
//  Created by Trung on 21/3/2023.
//

import Foundation
import Foundation
import UIKit
import FirebaseAuth
import SDWebImage


final class ProfileViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var coverPhoto: UIImageView!
    
    @IBOutlet weak var avaPhoto: UIImageView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "name")
        let actionSheet = UIAlertController(title: "Are you sure want to log out ?", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive,handler: {[weak self] _ in
            guard let strongSelf = self else{
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav,animated: false)
            }
            catch {
                print("Failed to log out")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        self.present(actionSheet,animated: true)
    }
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var coverButton: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaPhoto.layer.cornerRadius = 50
        avaPhoto.contentMode = .scaleAspectFill
        coverPhoto.contentMode = .scaleAspectFill
        coverPhoto.alpha = 0.5
        logoutButton.layer.cornerRadius = 20
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        emailField.layer.cornerRadius = 25
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        nameField.layer.cornerRadius = 25
        nameLabel.frame = CGRect(x: nameField.left + 16, y: nameField.top  , width: nameField.width - 32, height: nameField.height)
        emailLabel.frame = CGRect(x: emailField.left + 16, y: emailField.top  , width: emailField.width - 32, height: emailField.height)
        
        coverButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeCoverPhoto))
        coverButton.addGestureRecognizer(gesture)
        
        
        guard let email = UserDefaults.standard.value(forKey: "email")as? String else {
            return
        }
        guard let name = UserDefaults.standard.value(forKey: "name")as? String
        else {
            return
        }
        nameLabel.text = "Name : \(name)"
        emailLabel.text = "Email : \(email)"
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let coverPhotoname = safeEmail + "_cover_photo.png"
        let path = "images/"+filename
        let pathCover = "coverphotos/"+coverPhotoname
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result{
            case .success(let url):
                self.avaPhoto.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url : \(error)")
            }
        })
        StorageManager.shared.downloadURL(for: pathCover, completion: { result in
            switch result{
            case .success(let url):
                self.coverPhoto.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get cover photo: \(error)")
            }
        })
    }
    @objc func didTapChangeCoverPhoto(){
        presentPhotoActionSheet()
    }
}
extension ProfileViewController{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Cover Photo", message: "How would you like to select your picture ?", preferredStyle: .actionSheet)
        
        actionSheet.addAction((UIAlertAction(title: "Cancel", style: .cancel,handler: nil)))
        actionSheet.addAction((UIAlertAction(title: "Take Photo", style: .default,handler: {[weak self] _ in
            self?.presentCamera()
            
        })))
        actionSheet.addAction((UIAlertAction(title: "Choose Photo", style: .default,handler: { [weak self] _ in
            self?.presentPhotoPicker()
        })))
        present(actionSheet, animated: true)
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.coverPhoto.image = selectedImage
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = "\(safeEmail)_cover_photo.png"
        guard let image = self.coverPhoto.image, let data = image.pngData() else {
            return
        }
        StorageManager.shared.uploadCoverPicture(with: data, fileName: fileName, completion: { result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "cover_photo_url")
                print(downloadUrl)
            case .failure(let error):
                print("Storage manager error \(error)")
            }
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

