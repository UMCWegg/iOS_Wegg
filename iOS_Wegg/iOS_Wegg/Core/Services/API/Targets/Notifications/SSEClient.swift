//
//  SSEClient.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.19.
//

import Foundation
import UserNotifications

final class SSEClient {
    private var task: URLSessionDataTask?
    private let urlSession: URLSession
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(INT_MAX)
        configuration.timeoutIntervalForResource = TimeInterval(INT_MAX)
        self.urlSession = URLSession(configuration: configuration)
        
        // 알림 권한 요청
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        { granted, error in
            if granted {
                print("✅ 알림 권한 승인됨")
            } else {
                print("❌ 알림 권한 거부됨")
            }
        }
    }
    
    func subscribe(userId: String) {
        guard let url = URL(string: "https://weggserver.store/notifications/subscribe")
        else { return }
        
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(userId, forHTTPHeaderField: "Last-Event-ID")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ SSE 연결 오류: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let eventString = String(data: data, encoding: .utf8) else { return }
            
            print("📩 SSE 이벤트 수신: \(eventString)")
            
            // 서버에서 받은 이벤트를 알림으로 변환
            self?.showNotification(with: eventString)
        }
        
        task?.resume()
    }
    
    private func showNotification(with eventData: String) {
        // 알림 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = "알림"  // 서버 데이터에서 적절한 제목 추출
        content.body = eventData  // 서버 데이터에서 적절한 내용 추출
        content.sound = .default
        
        // 즉시 알림 표시
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil  // nil로 설정하면 즉시 표시
        )
        
        // 알림 예약
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ 알림 표시 실패: \(error.localizedDescription)")
            } else {
                print("✅ 알림 표시 성공")
            }
        }
    }
    
    func disconnect() {
        task?.cancel()
        task = nil
    }
}
