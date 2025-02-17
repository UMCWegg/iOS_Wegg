//
//  TodoResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/17/25.
//

import Foundation

/// Todo리스트 추가 response
struct TodoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TodoResult
}

/// Todo 리스트 결과 response
struct TodoResult: Decodable {
    let todoId: Int
    let content: String
    let status: String
    let createdAt: String
}

/// Todo리스트 달성 response
struct TodoAchievementResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Double
}

/// Todo리스트 조회 response
struct TodoListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [TodoResult]
}

/// Todo리스트 삭제 response
struct TodoDeleteResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DeletedTodoResult
}

/// 삭제 결과 response
struct DeletedTodoResult: Decodable {
    let todoId: Int
    let content: String
    let status: String
    let message: String
}
