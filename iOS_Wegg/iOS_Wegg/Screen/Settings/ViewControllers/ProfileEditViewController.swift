import UIKit

class ProfileEditViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileEditView = ProfileEditView()
    private let imagePicker = UIImagePickerController()
    private var isImageChanged = false // 이미지 변경 여부 추적
    
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
        } else {
            profileEditView.profileImageView.image = UIImage(named: "settings_wegg")
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
        guard let name = profileEditView.nameTextField.text, !name.isEmpty,
              let accountId = profileEditView.idTextField.text, !accountId.isEmpty else {
            showAlert(message: "이름과 아이디를 모두 입력해주세요.")
            return
        }
        
        // 로딩 인디케이터 표시
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
        
        // 이미지 데이터 준비
        let imageData: Data?
        if isImageChanged {
            imageData = profileEditView.profileImageView.image?.jpegData(compressionQuality: 0.8)
        } else {
            imageData = nil  // 이미지가 변경되지 않았으면 nil 전송 (서버에서 기존 이미지 유지)
        }
        
        Task {
            do {
                let response = try await SettingsService.shared.updateProfile(
                    name: name,
                    accountId: accountId,
                    profileImage: imageData
                )
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    activityIndicator.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    
                    if response.isSuccess {
                        // 로컬 저장소 업데이트
                        SettingsStorage.shared.saveProfileName(name)
                        SettingsStorage.shared.saveProfileId(accountId)
                        if let imageData = imageData, self.isImageChanged {
                            SettingsStorage.shared.saveProfileImage(imageData)
                        }
                        
                        // 성공 알림 표시
                        self.showAlert(message: "프로필이 업데이트되었습니다.", completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        // 실패 알림 표시
                        self.showAlert(message: response.message ?? "프로필 업데이트에 실패했습니다.")
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    activityIndicator.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    print("프로필 업데이트 실패: \(error)")
                    self.showAlert(message: "네트워크 오류: \(error.localizedDescription)")
                }
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
            } else {
                self.showAlert(message: "카메라에 접근할 수 없습니다.")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [library, camera, cancel].forEach { alert.addAction($0) }
        
        // iPad에서 액션시트 표시를 위한 처리
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = profileEditView.cameraButton
            popoverController.sourceRect = profileEditView.cameraButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    // 알림 표시 헬퍼 메서드
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
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
            isImageChanged = true // 이미지가 변경되었음을 표시
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
