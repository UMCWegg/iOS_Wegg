//
//  TodoRequest.swift
//  iOS_Wegg
//
//  Created by KKM on 2/17/25.
//

import Foundation

/// Todo 리스트 추가
struct TodoRequest: Encodable {
    let status: String
    let content: String
}

/// Todo 리스트 수정
struct TodoUpdateRequest: Encodable {
    let status: String
    let content: String
}

/// Todo 리스트 "DONE" 체크
struct TodoCheckRequest: Encodable {
    let status: String
}
