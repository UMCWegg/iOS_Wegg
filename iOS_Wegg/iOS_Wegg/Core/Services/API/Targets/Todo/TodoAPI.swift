//
//  TodoAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/16/25.
//

import Foundation
import Moya

enum TodoAPI {
    case addTodo(request: TodoRequest)
    case updateTodo(todoId: Int, request: TodoUpdateRequest)
    case checkTodo(todoId: Int, request: TodoCheckRequest)
    case getAchievement
    case getTodoList
    case deleteTodo(todoId: Int)
}

extension TodoAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }

    var path: String {
        switch self {
        case .addTodo:
            return APIConstants.Todo.addTodoListURL
        case .updateTodo(let todoId, _):
            return "/todo/\(todoId)"
        case .checkTodo(let todoId, _):
            return "/todo/\(todoId)/check"
        case .getAchievement:
            return "/todo/achievement"
        case .getTodoList:
            return "/todo"
        case .deleteTodo(let todoId):
            return "/todo/\(todoId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .addTodo: return .post
        case .updateTodo: return .patch
        case .checkTodo: return .patch
        case .getAchievement: return .get
        case .getTodoList: return .get
        case .deleteTodo: return .delete
        }
    }

    var task: Task {
        switch self {
        case .addTodo(let request):
            return .requestJSONEncodable(request)
        case .updateTodo(_, let request):
            return .requestJSONEncodable(request)
        case .checkTodo(_, let request):
            return .requestJSONEncodable(request)
        case .getAchievement, .getTodoList, .deleteTodo:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
