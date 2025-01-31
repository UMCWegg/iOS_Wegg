//
//  UserOccupation.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

enum UserOccupation: String, Codable {
    case employee = "직장인"
    case university = "대학생"
    case elementary = "초등학생"
    case secondary = "중・고등학생"
    case unemployed = "무직"
    case other = "기타"
    
    static var allCases: [String] {
        return [
            employee.rawValue,
            university.rawValue,
            elementary.rawValue,
            secondary.rawValue,
            unemployed.rawValue,
            other.rawValue
        ]
    }
    
    init?(from: String) {
        self.init(rawValue: from)
    }
}
