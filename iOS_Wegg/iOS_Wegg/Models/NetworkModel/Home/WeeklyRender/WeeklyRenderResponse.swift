//
//  WeeklyRenderResponse.swift
//  iOS_Wegg
//
//  Created by KKM on 2/18/25.
//

import Foundation

struct WeeklyRenderResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: WeeklyRenderResult
}

struct WeeklyRenderResult: Decodable {
    let weeklyData: [WeeklyData]
    let todayTodos: [WeeklyTodoResult]
    let totalTodos: Int
    let completedTodos: Int
    let completionRate: Double
    let successCount: Int
    let totalStudyTime: Int
    let upcomingPlanAddress: String?
    let availablePoints: Int
    let canReceivePoints: Bool
}

struct WeeklyData: Decodable {
    let date: String
    let plan: PlanData?
    let post: PostData?
}

struct PlanData: Decodable {
    let id: Int
    let startTime: String
    let endTime: String
    let status: String
    let eggStatus: String
}

struct PostData: Decodable {
    let id: Int
    let imageUrl: String
    let createdAt: String
}

struct WeeklyTodoResult: Decodable {
    let todoId: Int
    let content: String
    let status: String
    let createdAt: String
    let completed: Bool
}
