//
//  ContactPermissionViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

import Then
import SnapKit

class ContactPermissionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contactPermissionView = ContactPermissionView()
    private var contacts: [CNContact] = []
    private var contactFriends: [ContactFriend] = []
    private let authService = AuthService.shared
    private let followService = FollowService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contactPermissionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        contactPermissionView.tableView.delegate = self
        contactPermissionView.tableView.dataSource = self
    }
    
    private func setupActions() {
        contactPermissionView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        contactPermissionView.nextButton.isEnabled = false
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            guard let self = self else { return }
            
            if granted {
                // 연락처 접근이 허용된 경우
                Task { @MainActor in
                    do {
                        let contacts = try await self.fetchAllContacts()
                        UserSignUpStorage.shared.update { data in
                            data.contact = contacts.map { Contact(phone: $0) }
                        }
                        await self.signUp()
                        self.contactPermissionView.nextButton.isEnabled = true
                    } catch {
                        print("Error fetching contacts: \(error)")
                        self.proceedWithoutContacts()
                    }
                }
            } else {
                // 연락처 접근이 거부된 경우
                DispatchQueue.main.async {
                    self.proceedWithoutContacts()
                }
            }
        }
    }
    
    private func fetchAllContacts() async throws -> [String] {
        let store = CNContactStore()
        let keysToFetch = [CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var phoneNumbers: [String] = []
        
        try await withCheckedThrowingContinuation
        { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                        // 전화번호 형식 정리
                        let cleanNumber = phoneNumber
                            .replacingOccurrences(of: "(", with: "")
                            .replacingOccurrences(of: ")", with: "")
                            .replacingOccurrences(of: " ", with: "")
                            .replacingOccurrences(of: "-", with: "")
                        
                        // 한국 전화번호 형식(01로 시작)만 필터링
                        if cleanNumber.hasPrefix("01") {
                            phoneNumbers.append(cleanNumber)
                        }
                    }
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
        
        return phoneNumbers
    }
    
    private func proceedWithoutContacts() {
        UserSignUpStorage.shared.update { data in
            data.contact = []
        }
        signUp()
    }
    
    private func signUp() {
        Task {
            do {
                guard let signUpData = UserSignUpStorage.shared.get() else { return }
                print("📝 SignUp Request Data Check:")
                print("- email: \(signUpData.email ?? "nil")")
                print("- password: \(signUpData.password != nil ? "exists" : "nil")")
                print("- marketingAgree: \(signUpData.marketingAgree ?? false)")
                print("- accountId: \(signUpData.accountId ?? "nil")")
                print("- name: \(signUpData.name ?? "nil")")
                print("- job: \(signUpData.job?.rawValue ?? "nil")")
                print("- reason: \(signUpData.reason?.rawValue ?? "nil")")
                print("- phone: \(signUpData.phone ?? "nil")")
                print("- alarm: \(signUpData.alarm ?? false)")
                print("- contact: \(signUpData.contact?.description ?? "nil")")
                print("- socialType: \(signUpData.socialType?.rawValue ?? "nil")")
                print("- accessToken: \(signUpData.accessToken?.prefix(10) ?? "nil")...")
                
                let request = signUpData.toSignUpRequest()
                let response: SignUpResponse
                
                if signUpData.socialType == .email {
                    response = try await authService.signUp(request: request)
                } else {
                    response = try await authService.socialSignUp(request: request)
                }
                
                await MainActor.run {
                    if response.isSuccess {
                        self.handleSignUpSuccess(response)
                    }
                }
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }
    
    private func handleSignUpSuccess(_ response: SignUpResponse) {
        UserDefaultsManager.shared.saveUserID(Int(response.result.userID))
        
        loginAfterSignup { [weak self] success in
            guard let self = self else { return }
            
            if success {
                // 로그인 성공(쿠키 설정됨) 후 연락처 친구 표시
                if let contactFriends = response.result.contactFriends, !contactFriends.isEmpty {
                    self.contactFriends = contactFriends
                    
                    DispatchQueue.main.async {
                        self.contactPermissionView.contentBox.isHidden = false
                        self.contactPermissionView.tableView.reloadData()
                        
                        self.contactPermissionView.nextButton.removeTarget(
                            self,
                            action: #selector(self.nextButtonTapped),
                            for: .touchUpInside)
                        self.contactPermissionView.nextButton.addTarget(
                            self,
                            action: #selector(self.proceedToNextScreen),
                            for: .touchUpInside)
                        self.contactPermissionView.nextButton.isEnabled = true
                    }
                } else {
                    self.moveToMainScreen()
                }
            } else {
                // 로그인 실패해도 회원가입 완료 화면으로 이동
                self.moveToMainScreen()
            }
        }
    }
    
    private func loginAfterSignup(completion: @escaping (Bool) -> Void) {
        guard let signUpData = UserSignUpStorage.shared.get() else {
            completion(false)
            return
        }
        
        Task {
            do {
                // 명시적으로 타입을 선언
                let loginResponse: LoginResponse
                
                // 이메일 로그인과 소셜 로그인을 분리하지 않고 하나의 LoginRequest로 처리
                let loginRequest = LoginRequest(
                    email: signUpData.email ?? "",
                    password: signUpData.password,
                    socialType: signUpData.socialType,
                    accessToken: signUpData.socialType == .email ? nil : signUpData.accessToken
                )
                
                // 로그인 방식에 따라 적절한 API 호출
                if signUpData.socialType == .email {
                    loginResponse = try await authService.login(request: loginRequest)
                } else {
                    loginResponse = try await authService.socialLogin(request: loginRequest)
                }
                
                // 결과 처리
                await MainActor.run {
                    if loginResponse.isSuccess, let result = loginResponse.result {
                        UserDefaultsManager.shared.saveUserID(result.userID)
                        print("✅ 회원가입 후 로그인 성공 - 쿠키가 설정되었습니다")
                        completion(true)
                    } else {
                        print("❌ 회원가입 후 로그인 실패: \(loginResponse.message)")
                        completion(false)
                    }
                }
            } catch {
                print("❌ 회원가입 후 로그인 오류: \(error)")
                completion(false)
            }
        }
    }
    
    private func moveToMainScreen() {
        let signUpCompleteVC = SignUpCompleteViewController()
        navigationController?.pushViewController(signUpCompleteVC, animated: true)
    }
    
    @objc private func proceedToNextScreen() {
        moveToMainScreen()
    }
    
    private func handleFollow(friendId: Int, state: ContactFriendCell.FollowState) {
        Task {
            do {
                // 해당 셀 찾기
                if let index = contactFriends.firstIndex(where: { $0.friendID == friendId }),
                   let cell = contactPermissionView.tableView
                    .cellForRow(at: IndexPath(row: index, section: 0)) as? ContactFriendCell {
                    
                    let response: BaseResponse<FollowResponse>
                    
                    if state == .pending {
                        response = try await followService.follow(followeeId: friendId)
                        
                        await MainActor.run {
                            if response.result.followStatus == "SUCCEEDED" {
                                cell.setState(.success)
                            } else {
                                cell.setState(.follow) // 원래 상태로 복구
                            }
                        }
                    } else {
                        response = try await followService.unfollow(followeeId: friendId)
                        
                        await MainActor.run {
                            cell.setState(.follow)
                        }
                    }
                    
                    // 버튼 다시 활성화
                    await MainActor.run {
                        cell.followButton.isEnabled = true
                    }
                }
            } catch {
                print("Follow operation failed: \(error)")
                
                // 실패 시 원래 상태로 복원
                await MainActor.run {
                    if let index = contactFriends
                        .firstIndex(where: { $0.friendID == friendId }),
                       let cell = contactPermissionView.tableView
                        .cellForRow(at: IndexPath(row: index, section: 0)) as? ContactFriendCell {
                        cell.setState(state == .pending ? .follow : .pending)
                        cell.followButton.isEnabled = true
                    }
                }
            }
        }
    }
}

extension ContactPermissionViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ContactFriendCell",
            for: indexPath
        ) as? ContactFriendCell else { return UITableViewCell() }
        
        let friend = contactFriends[indexPath.row]
        cell.configure(with: friend)
        
        cell.followStateChanged = { [weak self] friendId, state in
            self?.handleFollow(friendId: friendId, state: state)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
