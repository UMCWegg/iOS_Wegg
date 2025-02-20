//
//  MonthlyRenderAPI.swift
//  iOS_Wegg
//
//  Created by KKM on 2/20/25.
//

import Foundation
import Moya

enum MonthlyRenderAPI {
    case fetchCurrentMonth
    case fetchSpecificMonth(year: Int, month: Int)
}

extension MonthlyRenderAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIConstants.baseURL) else {
            fatalError("❌ 잘못된 Base URL: \(APIConstants.baseURL)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchCurrentMonth:
            return APIConstants.MonthlyRenderURL.monthlyRenderURL
        case .fetchSpecificMonth(let year, let month):
            return APIConstants.MonthlyRenderURL.calendarURL(year: year, month: month)
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}

// APIManager를 사용하여 요청을 보내는 extension
extension APIManager {
    func fetchMonthlyData(
        year: Int? = nil,
        month: Int? = nil
    ) async throws -> MonthlyRenderResponse {
        let target: MonthlyRenderAPI
        if let year = year, let month = month {
            target = .fetchSpecificMonth(year: year, month: month)
        } else {
            target = .fetchCurrentMonth
        }
        
        return try await request(target: target)
    }
}
