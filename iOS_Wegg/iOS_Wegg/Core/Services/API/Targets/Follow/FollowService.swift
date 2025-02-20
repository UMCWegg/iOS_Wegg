//
//  FollowService.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

final class FollowService {
    static let shared = FollowService()
    private let apiManager = APIManager()
    
    private init() {}
    
    func follow(followeeId: Int) async throws -> BaseResponse<FollowResponse> {
        return try await apiManager.request(target: FollowInfoAPI.follow(followeeId: followeeId)) 
    }
    
    func unfollow(followeeId: Int) async throws -> BaseResponse<FollowResponse> {
        return try await apiManager.request(target: FollowInfoAPI.unfollow(followeeId: followeeId))
    }
}
