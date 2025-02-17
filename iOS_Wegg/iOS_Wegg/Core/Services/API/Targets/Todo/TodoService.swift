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

    // 투두 등록
    func addTodo(_ request: TodoRequest) async -> Result<TodoResult, Error> {
        do {
            let response: TodoResponse = try await apiManager.request(
                target: TodoAPI.addTodo(request: request)
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }

    // 투두 수정
    func updateTodo(todoId: Int, request: TodoUpdateRequest) async -> Result<TodoResult, Error> {
        do {
            let response: TodoResponse = try await apiManager.request(
                target: TodoAPI.updateTodo(todoId: todoId, request: request)
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }

    // 투두 달성 체크
    func checkTodo(todoId: Int, request: TodoCheckRequest) async -> Result<TodoResult, Error> {
        do {
            let response: TodoResponse = try await apiManager.request(
                target: TodoAPI.checkTodo(todoId: todoId, request: request)
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }

    // 달성률 조회
    func getAchievement() async -> Result<Int, Error> {
        do {
            let response: TodoAchievementResponse = try await apiManager.request(
                target: TodoAPI.getAchievement
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }

    // 투두 리스트 조회
    func getTodoList() async -> Result<[TodoResult], Error> {
        do {
            let response: TodoListResponse = try await apiManager.request(
                target: TodoAPI.getTodoList
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }

    // 투두 삭제
    func deleteTodo(todoId: Int) async -> Result<TodoResult, Error> {
        do {
            let response: TodoDeleteResponse = try await apiManager.request(
                target: TodoAPI.deleteTodo(todoId: todoId)
            )
            return .success(response.result)
        } catch {
            return .failure(error)
        }
    }
}
