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
        
        if let contactFriends = response.result.contactFriends, !contactFriends.isEmpty {
            self.contactFriends = contactFriends
            contactPermissionView.contentBox.isHidden = false
            contactPermissionView.tableView.reloadData()
            
            contactPermissionView.nextButton.removeTarget(
                self,
                action: #selector(nextButtonTapped),
                for: .touchUpInside)
            contactPermissionView.nextButton.addTarget(
                self,
                action: #selector(proceedToNextScreen),
                for: .touchUpInside)
            contactPermissionView.nextButton.isEnabled = true
        } else {
            moveToMainScreen()
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
