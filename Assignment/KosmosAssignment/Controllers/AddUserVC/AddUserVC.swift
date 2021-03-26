//
//  AddUserVC.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit

class AddUserVC: UITableViewController {
    
    //MARK:- IBOutlet
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var txtFirstName:UITextField!
    @IBOutlet private weak var txtLastName:UITextField!
    @IBOutlet private weak var txtEmail:UITextField!
    @IBOutlet private weak var btnSave: UIBarButtonItem!
    
    private var profileUrl:URL?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        /// ImageView
        imgProfile.layer.cornerRadius = imgProfile.bounds.height/2
        imgProfile.layer.borderWidth = 3
        imgProfile.layer.borderColor = UIColor.link.cgColor
        imgProfile.clipsToBounds = true
        
        /// TextField
        txtEmail.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtLastName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtFirstName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        btnSave.isEnabled = false
    }
    
    private func saveImage() -> URL? {
        if profileUrl != nil, let data = imgProfile.image?.jpegData(compressionQuality:  1.0) {
            let cachedFile = FileManager.default.temporaryDirectory
                .appendingPathComponent(
                    profileUrl!.lastPathComponent,
                    isDirectory: false
                )
            
            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: cachedFile.path) {
                    try FileManager.default.removeItem(at: cachedFile)
                }
                
                // Copy the tempURL to file
                
                try data.write(to: cachedFile)
                print("file saved")
                return URL(string: "\(baseURL)img/faces/\(cachedFile.lastPathComponent)")
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func validateTextField() {
        let firstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
        let lastName = txtLastName.text!.trimmingCharacters(in: .whitespaces)
        let email = txtEmail.text!.trimmingCharacters(in: .whitespaces)
        btnSave.isEnabled = false

        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty  {
            btnSave.isEnabled = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    // MARK:- IBAction
    @objc private func textFieldDidChange(_ textField:UITextField) {
        validateTextField()
    }
    @IBAction func onBtnProfileAction(_ sender:Any) {
        self.view.endEditing(true)
        openImagePicker()
    }
    
    @IBAction func onBtnSaveAction(_ sender: Any) {
        self.view.endEditing(true)
        let email = txtEmail.text!.trimmingCharacters(in: .whitespaces)

        if !isValidEmail(email) {
            self.showAlert(message: "Please enter valid email address")
            return
        }        
        let user = User(id: nil, email: txtEmail.text!.trimmingCharacters(in: .whitespaces), firstName: txtFirstName.text!.trimmingCharacters(in: .whitespaces), lastName: txtLastName.text!.trimmingCharacters(in: .whitespaces), avatar: saveImage()?.absoluteString)
        let userRepository = UserDataRepository()
        if userRepository.create(user) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}
// MAKR:- UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("info:=",info)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
//        print("profileUrl:=",profileUrl ?? nil)
        imgProfile.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true , completion: nil)
    }
}
