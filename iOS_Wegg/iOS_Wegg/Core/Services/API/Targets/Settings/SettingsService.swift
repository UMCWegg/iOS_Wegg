//
//  SettingsService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

import Foundation

final class SettingsService {
   static let shared = SettingsService()
   private let apiManager = APIManager()
   
   private init() {}
   
   func updateProfile(name: String,
                      accountId: String,
                      profileImage: Data?) async throws -> BaseResponse<EmptyResponse> {
        return try await apiManager.request(
            target: SettingsAPI.updateProfile(
                name: name,
                accountId: accountId,
                profileImage: profileImage
            )
        )
    }
    
    func updateSettings(settings: SettingsUpdateRequest) async throws -> BaseResponse<String> {
        return try await apiManager.request(
            target: SettingsAPI.updateSettings(settings: settings)
        )
    }
}
