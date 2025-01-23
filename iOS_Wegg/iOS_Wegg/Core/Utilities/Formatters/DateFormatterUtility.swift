//
//  DateFormatter.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/23/25.
//

import Foundation

class DateFormatterUtility {
    /// 날짜를 포맷팅하여 문자열로 변환해줌
    /// - DateFormatterUtility.formattedDate(date)
    static func formattedDate(_ date: Date) -> String {
        // DateFormatter 초기화
        let formatter = DateFormatter()
        
        // 날짜 스타일 설정 (예: "Jan 20, 2025")
        formatter.dateStyle = .medium
        
        // 시간 스타일 설정 (예: "2:34 PM")
        formatter.timeStyle = .short
        
        // Date 객체를 문자열로 변환
        return formatter.string(from: date)
    }
}
