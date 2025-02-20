//
//  MonthlyRenderResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/20/25.
//

import Foundation

struct MonthlyRenderResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MonthlyResult
}

struct MonthlyResult: Codable {
    let monthlyData: [DayData]
    let dateSummaries: [DateSummary]
}

struct DayData: Codable {
    let date: String
    let plan: Plan?
    let post: Post?
}

struct Plan: Codable {
    let id: Int
    let startTime: String
    let endTime: String
    let status: String
    let eggStatus: String
}

struct Post: Codable {
    let id: Int
    let imageUrl: String
    let createdAt: String
}

struct DateSummary: Codable {
    let date: String
    let studyTime: Int
    let completionRate: Double
    let hasFailedPlan: Bool
}
