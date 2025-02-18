//
//  TodoResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/16/25.
//

import Foundation

struct TodoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TodoResult
    
    struct TodoResult: Decodable {
        let todoId: Int
        let content: String
        let status: String
        let createdAt: String
    }
}
