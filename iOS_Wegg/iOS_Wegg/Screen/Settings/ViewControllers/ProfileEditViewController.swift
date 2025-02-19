//
//  ProfileEditViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileEditView = ProfileEditView()
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellowBg
        setupInitialData()
        setupImagePicker()
        setupButtons()
    }
    
    // MARK: - Setup
    
    private func setupButtons() {
        profileEditView.cancelButton.addTarget(self,
                                               action: #selector(cancelButtonTapped),
                                               for: .touchUpInside)
        
        profileEditView.saveButton.addTarget(self,
                                             action: #selector(saveButtonTapped),
                                             for: .touchUpInside)
        
        profileEditView.cameraButton.addTarget(self,
                                               action: #selector(cameraButtonTapped),
                                               for: .touchUpInside)
    }
    
    private func setupInitialData() {
        profileEditView.nameTextField.text = SettingsStorage.shared.getProfileName()
        profileEditView.idTextField.text = SettingsStorage.shared.getProfileId()
        
        if let imageData = SettingsStorage.shared.getProfileImage(),
           let image = UIImage(data: imageData) {
            profileEditView.profileImageView.image = image
        }
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let name = profileEditView.nameTextField.text,
              let accountId = profileEditView.idTextField.text else { return }
        
        // 이미지가 기본 이미지가 아닐 경우에만 전송
        let imageData: Data?
        = profileEditView.profileImageView.image == UIImage(named: "settings_wegg")
            ? nil
            : profileEditView.profileImageView.image?.jpegData(compressionQuality: 0.8)
        
        Task {
            do {
                let response = try await SettingsService.shared.updateProfile(
                    name: name,
                    accountId: accountId,
                    profileImage: imageData
                )
                
                if response.isSuccess {
                    // 로컬 저장소 업데이트
                    SettingsStorage.shared.saveProfileName(name)
                    SettingsStorage.shared.saveProfileId(accountId)
                    if let imageData = imageData {
                        SettingsStorage.shared.saveProfileImage(imageData)
                    }
                    
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                print("프로필 업데이트 실패: \(error)")
            }
        }
    }
    
    @objc private func cameraButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [library, camera, cancel].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileEditViewController: UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            profileEditView.profileImageView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
