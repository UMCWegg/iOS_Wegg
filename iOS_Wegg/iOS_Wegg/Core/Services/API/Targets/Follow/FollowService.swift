final class FollowService {
    static let shared = FollowService()
    private let apiManager = APIManager()
    
    private init() {}
    
    func follow(followeeId: Int) async throws -> BaseResponse<FollowResponse> {
        return try await apiManager.request(target: FollowAPI.follow(followeeId: followeeId))
    }
    
    func unfollow(followeeId: Int) async throws -> BaseResponse<FollowResponse> {
        return try await apiManager.request(target: FollowAPI.unfollow(followeeId: followeeId))
    }
}