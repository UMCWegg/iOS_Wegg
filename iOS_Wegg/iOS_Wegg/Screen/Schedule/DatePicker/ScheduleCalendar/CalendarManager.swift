//
//  CalendarManager.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/11/25.
//

import Foundation

class CalendarManager {
    
    private var selectedDate: Date
    private let calendar: Calendar

    /// 날짜 포맷터 (yyyy년 M월)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    /// 날짜 포맷터 (yyyy-MM-dd)
    private let hyphenDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()

    /// 초기화 - 현재 월을 기준으로 설정
    init() {
        // 앱 실행 시, 현재 날짜의 연도와 월을 기준으로 selectedDate 초기화
        calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        self.selectedDate = calendar.date(from: components) ?? now
    }

    /// 현재 선택된 날짜를 "yyyy년 M월" 형식으로 반환
    func getFormattedDate() -> String {
        return dateFormatter.string(from: selectedDate)
    }
    
    /// 현재 선택된 날짜를 "yyyy-MM" 형식으로 반환
    func getFormattedDateWithHyphen() -> String {
        return hyphenDateFormatter.string(from: selectedDate)
    }

    /// 이전 달로 변경
    func goToPreviousMonth() {
        guard let newDate = Calendar.current.date(
            byAdding: .month, value: -1, to: selectedDate
        ) else { return }
        selectedDate = newDate
    }

    /// 다음 달로 변경
    func goToNextMonth() {
        guard let newDate = Calendar.current.date(
            byAdding: .month, value: 1, to: selectedDate
        ) else { return }
        selectedDate = newDate
    }
    
    /// 현재 선택된 년도 (`yyyy`)
    func getYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: selectedDate)
    }
    
    /// 현재 선택된 월 (`M`)
    func getMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: selectedDate)
    }
}
