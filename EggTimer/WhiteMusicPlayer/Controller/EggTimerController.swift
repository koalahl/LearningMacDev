//
//  EggTimerController.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/15.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Cocoa
import AVFoundation

class EggTimerController: NSViewController {

    @IBOutlet weak var remainTimeLabel: NSTextField!
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var stopBtn: NSButton!
    @IBOutlet weak var resetBtn: NSButton!
    
    var eggTimer = EggTimer()
    var prefs = Preferences()
    var circle = Circle()
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        eggTimer.delegate = self
        
        setupPrefs()
    }
    
    func dealloc() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupPrefs() {
        //set time duration from disk
        updateDisplay(for: prefs.selectedTime)
        let notificationName = NSNotification.Name(rawValue:"PrefsChanged")
        //NotificationCenter.default.addObserver(self, selector: Selector("updateFromPrefs"), name: notificationName, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(EggTimerController.updateFromPrefs), name: notificationName, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(updateFromPrefs), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
            //add a alert to confirm
            self.checkForResetAfterPrefsChange()
            //self.updateFromPrefs()
        }
    }
    
    @IBAction func start(_ sender: Any) {
        if eggTimer.isPaused {
            eggTimer.resumeTimer()
        }else {
            eggTimer.duration = prefs.selectedTime
            eggTimer.startTimer()
        }
        
        configureButtonsAndMenus()
        prepareSound()
    }
    
    @IBAction func stop(_ sender: Any) {
        eggTimer.stopTimer()
        configureButtonsAndMenus()
        
    }
    
    @IBAction func reset(_ sender: Any) {
        eggTimer.resetTimer()
        updateDisplay(for: prefs.selectedTime)
        configureButtonsAndMenus()
        
    }
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        start(sender)
    }
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stop(sender)
    }
    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
        reset(sender)
    }
    
    @objc func updateFromPrefs() {
        self.eggTimer.duration = prefs.selectedTime
        self.reset(self)
    }
    
}

//MARK: - EggTimer Delegate
extension EggTimerController : EggTimerProtocol {
    func timeHasFinished(_ timer: EggTimer) {
        updateDisplay(for: 0)
        //play sound
        playSound()
    }
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
        let percent = CGFloat((self.eggTimer.duration - timeRemaining)/self.eggTimer.duration)
        circle.progress = percent
        
    }
}

//MARK: - Update UI

extension EggTimerController {
    
    func updateDisplay(for timeRemaining: TimeInterval) {
        remainTimeLabel.stringValue = textToDisplay(for: timeRemaining)
        //TODO: can update time circle.圆圈
    }
    private func textToDisplay(for timeRemaining: TimeInterval) ->String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining/60)
        let minutesDisplay = String(format: "%02d", Int(minutesRemaining))
        let secondsRemaining = timeRemaining - minutesRemaining*60
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(minutesDisplay):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    /**set the buttons enable status*/
    func configureButtonsAndMenus() {
        let enableStart:Bool
        let enableStop:Bool
        let enableReset:Bool
        
        if eggTimer.isStopped {//ready to start
            enableStart = true
            enableStop  = false
            enableReset = false
        }else if eggTimer.isPaused {//pause
            enableStart = true
            enableStop  = false
            enableReset = true
        }else {//running
            enableStart = false
            enableStop  = true
            enableReset = false
        }
        startBtn.isEnabled = enableStart
        stopBtn.isEnabled = enableStop
        resetBtn.isEnabled = enableReset
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
}

//MARK: - Alert

extension EggTimerController {
    
    func checkForResetAfterPrefsChange() {
        if eggTimer.isStopped || eggTimer.isPaused {
            updateFromPrefs()
        }else {
            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

//MARK: - Sound
extension EggTimerController {
    func prepareSound() {
        guard let audioFile = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
            audioPlayer?.prepareToPlay()
        } catch  {
            print("Sound File not available:\(error)")
        }
    }
    
    func playSound() {
        audioPlayer?.play()
    }
}
