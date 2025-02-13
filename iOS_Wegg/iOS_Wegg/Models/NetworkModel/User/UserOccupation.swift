//
//  UserOccupation.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

// UserOccupation.swift 수정
enum UserOccupation: String, Codable {
    case employee = "EMPLOYEE"
    case university = "UNIVERSITY"
    case elementary = "ELEMENTARY"
    case secondary = "SECONDARY"
    case unemployed = "UNEMPLOYED"
    case other = "OTHER"
    
    var displayName: String {
        switch self {
            case .employee: return "직장인"
            case .university: return "대학생"
            case .elementary: return "초등학생"
            case .secondary: return "중・고등학생"
            case .unemployed: return "무직"
            case .other: return "기타"
        }
    }
    
    static var allCases: [String] {
        return [
            employee.displayName,
            university.displayName,
            elementary.displayName,
            secondary.displayName,
            unemployed.displayName,
            other.displayName
        ]
    }
    
    init?(from displayName: String) {
        switch displayName {
        case "직장인": self = .employee
        case "대학생": self = .university
        case "초등학생": self = .elementary
        case "중・고등학생": self = .secondary
        case "무직": self = .unemployed
        case "기타": self = .other
        default: return nil
        }
    }
}
