//
//  PostDetailService.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/21/25.
//

import Foundation

class PostDetailService {
    private let apiManager = APIManager()
    
    /// 📌 댓글 & 이모지 데이터를 동시에 가져오기
    func fetchCommentsAndEmojis(
        postId: Int, page: Int = 0, size: Int = 15
    ) async throws -> (comments: [Comment], emojis: EmojiResult) {
        do {
            // ✅ CommentResponse로 받아서 result를 가져옴
            async let commentsResponse: CommentResponse = try apiManager.request(
                target: PostDetailAPI.getComments(postId: postId, page: page, size: size)
            )
            async let emojisResponse: EmojiResponse = try apiManager.request(
                target: PostDetailAPI.getEmojis(postId: postId)
            )
            
            // ✅ result에서 배열 & 객체 가져오기
            let (comments, emojis) = try await (commentsResponse.result, emojisResponse.result)
            
            return (comments, emojis)
        } catch {
            print("❌ 댓글 및 이모지 데이터 조회 실패: \(error)")
            throw APIError.decodingError // ✅ 디코딩 실패 시 예외 처리
        }
    }
    
    /// 📌 이모지 등록 (서버 응답 활용)
    func postEmoji(postId: Int) async throws -> BaseResponse<String> {
        return try await apiManager.request(target: PostDetailAPI.postEmoji(postId: postId))
    }
    
    /// 📌 댓글 등록 (서버 응답 활용)
    func postComment(
        postId: Int, content: String, parentId: Int? = nil) async throws ->
    BaseResponse<String> {
        let request = CommentRequest(postingId: postId, comment: content, parentId: parentId)
        return try await apiManager.request(target: PostDetailAPI.postComment(request: request))
    }
}
