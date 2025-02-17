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
        }
    }

    var method: Moya.Method {
        switch self {
        case .addTodo:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .addTodo(let request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
