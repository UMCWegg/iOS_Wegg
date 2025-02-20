//
//  BrowseRequest.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/12/25.
//

import Foundation

/// 페이지네이션을 위한 요청 모델
struct BrowseRequest {
    let page: Int
    let size: Int
    
    func toParameters() -> [String: Any] {
        return ["page": page, "size": size]
    }
}
