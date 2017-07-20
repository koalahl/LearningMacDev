//
//  EggTimer.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/16.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Foundation

protocol EggTimerProtocol {
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    func timeHasFinished(_ timer: EggTimer)
}

class EggTimer {
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 360 //default is 6 min
    var elapsedTime: TimeInterval = 0
    var delegate: EggTimerProtocol?
    
    //computed properties
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    @objc dynamic func timerAction() {
        guard let startTime = startTime else{return}
        
        elapsedTime = -startTime.timeIntervalSinceNow
        
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timeHasFinished(self)
        }else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
        
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        timerAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerAction()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        timerAction()
        
    }
    
    func resetTimer() {
        //set to default
        startTime = nil
        duration = 360
        elapsedTime = 0
        
        stopTimer()
    }
}
