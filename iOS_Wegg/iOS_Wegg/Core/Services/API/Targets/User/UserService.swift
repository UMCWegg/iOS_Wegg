//
//  UserService.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

class UserService {
    private let apiManager = APIManager()

    /// 📌 사용자 검색 API 호출
    func searchUser(keyword: String) async throws -> [UserSearchResult] {
        do {
            let response: UserSearchResponse = try await apiManager.request(
                target: UserAPI.searchUser(keyword: keyword)
            )
            
            guard response.isSuccess else {
                throw APIError.networkError(response.message)
            }
            
            return response.result
        } catch {
            print("❌ 사용자 검색 API 호출 실패: \(error)")
            throw APIError.decodingError
        }
    }
}
