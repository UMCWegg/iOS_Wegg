//
//  MonthlyRenderResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/20/25.
//

import Foundation

struct MonthlyRenderResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MonthlyRenderResult
}

struct MonthlyRenderResult: Decodable {
    let monthlyData: [MonthlyRenderData]
    let dateSummaries: [MonthlyDateSummary]
}

struct MonthlyRenderData: Decodable {
    let date: String
    let plan: MonthlyPlanData?
    let post: MonthlyPostData?
}

struct MonthlyPlanData: Decodable {
    let id: Int
    let startTime: String
    let endTime: String
    let status: String
    let eggStatus: String
}

struct MonthlyPostData: Decodable {
    let id: Int
    let imageUrl: String
    let createdAt: String
}

struct MonthlyDateSummary: Decodable {
    let date: String
    let studyTime: Int
    let completionRate: Double
    let hasFailedPlan: Bool
}
