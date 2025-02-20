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
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.fetchContacts()
                } else {
                    self?.proceedWithoutContacts()
                }
            }
        }
    }
    
    private func fetchContacts() {
        let store = CNContactStore()
        let keysToFetch = [
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        do {
            let containers = try store.containers(matching: nil)
            var phoneNumbers: [String] = []
            
            try containers.forEach { container in
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                
                contacts.forEach { contact in
                    if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                        // 전화번호 형식 통일 (하이픈 제거)
                        let formattedNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                        phoneNumbers.append(formattedNumber)
                    }
                }
            }
            
            UserSignUpStorage.shared.update { data in
                data.contact = phoneNumbers.map { Contact(phone: $0) }
            }
            
            signUp()
            
        } catch {
            print("Error fetching contacts: \(error)")
            proceedWithoutContacts()
        }
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
        } else {
            moveToMainScreen()
        }
    }
    
    private func moveToMainScreen() {
        let signUpCompleteVC = SignUpCompleteViewController()
        navigationController?.pushViewController(signUpCompleteVC, animated: true)
    }
    
    private func follow(friendId: Int) {
        // 팔로우 API 호출을 위한 빈 구조체 생성
        struct FollowRequest: Encodable {
            let followeeId: Int
        }
        
        Task {
            do {
                let request = FollowRequest(followeeId: friendId)
                // API 호출 구현 필요
            } catch {
                print("Follow failed: \(error)")
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
        
        cell.followButtonTapped = { [weak self] in
            self?.follow(friendId: friend.friendID)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
