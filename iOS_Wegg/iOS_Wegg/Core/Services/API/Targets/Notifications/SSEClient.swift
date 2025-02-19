//
//  SSEClient.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.19.
//
import Foundation

final class SSEClient {
    private var eventSource: URLSessionDataTask?
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default

        // 타임아웃 설정 변경
        configuration.timeoutIntervalForRequest = TimeInterval(INT_MAX)
        configuration.timeoutIntervalForResource = TimeInterval(INT_MAX)
        
        self.session = URLSession(configuration: configuration)
    }
    
    func subscribe(userId: String) {
        guard let url = URL(string: APIConstants.baseURL
                            + APIConstants.Notification.subscribe) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(userId, forHTTPHeaderField: "Last-Event-ID")
        
        // Keep-Alive 설정 추가
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        print("✅ SSE 구독 시작 - User ID: \(userId)")
        
        eventSource = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ SSE 연결 오류: \(error.localizedDescription)")
                // 연결 실패시 재연결 시도
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self?.subscribe(userId: userId)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 SSE 연결 상태: \(httpResponse.statusCode)")
            }
            
            // 데이터 처리
            if let data = data,
               let message = String(data: data, encoding: .utf8) {
                print("📨 SSE 메시지 수신: \(message)")
            }
        }
        
        eventSource?.resume()
    }
    
    func disconnect() {
        print("❌ SSE 연결 종료")
        eventSource?.cancel()
        eventSource = nil
    }
}
