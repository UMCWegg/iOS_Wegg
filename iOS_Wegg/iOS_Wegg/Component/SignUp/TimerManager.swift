//
//  TimerManager.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.20.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    private var timer: Timer?
    private var remainingTime: Int = 180 // 3분
    var timerCallback: ((Int) -> Void)?
    var timerExpiredCallback: (() -> Void)?
    
    func startTimer() {
        remainingTime = 180
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.remainingTime -= 1
            self.timerCallback?(self.remainingTime)
            
            if self.remainingTime <= 0 {
                self.stopTimer()
                self.timerExpiredCallback?()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func getFormattedTime() -> String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
