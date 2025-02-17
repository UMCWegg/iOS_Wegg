//
//  TodoService.swift
//  iOS_Wegg
//
//  Created by KKM on 2/16/25.
//

import Foundation
import Moya

class TodoService {
    private let apiManager = APIManager()

    func addTodo(_ request: TodoRequest) async -> Result<TodoResult, Error> {
        do {
            let response: TodoResponse = try await apiManager.request(
                target: TodoAPI.addTodo(request: request)
            )
            print("✅ [TodoService] 투두 등록 성공: \(response.result.content)")
            return .success(response.result)
        } catch {
            print("❌ [TodoService] 투두 등록 실패: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
