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
        self.session = URLSession(configuration: configuration)
    }
    
    func subscribe(userId: String) {
        guard let url = URL(string: APIConstants.baseURL
                            + APIConstants.Notification.subscribe) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(userId, forHTTPHeaderField: "Last-Event-ID")
        
        print("✅ SSE 구독 시작 - User ID: \(userId)")
        
        eventSource = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ SSE 연결 오류: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 SSE 연결 상태: \(httpResponse.statusCode)")
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
