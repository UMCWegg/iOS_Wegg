//
//  OnOffScheduleResponse.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/19/25.
//

import Foundation

struct OnOffScheduleResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: OnOffResult
    
    struct OnOffResult: Decodable {
        let planId: Int
        let createdAt: String
        let warningMessage: String?
    }
}
