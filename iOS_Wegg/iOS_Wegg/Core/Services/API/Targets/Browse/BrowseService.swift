//
//  BrowseService.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/12/25.
//
import Foundation

struct BrowseService {
    
    let apiManager = APIManager()

    /// 둘러보기 API 요청
    func fetchBrowsePosts(page: Int, size: Int) async throws -> [[BrowsePost]] {
        let request = BrowseRequest(page: page, size: size)
        let response: BrowseResponse = try await apiManager.request(
            target: BrowseAPI.fetchBrowsePosts(request: request)
        )
        return response.result
    }
}
