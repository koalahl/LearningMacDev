//
//  PrefsViewController.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/15.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {
    
    @IBOutlet weak var presetsPopupBtn: NSPopUpButton!
    @IBOutlet weak var customTimeLabel: NSTextField!
    @IBOutlet weak var customSlider: NSSlider!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
    @IBAction func popupValueChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            customSlider.isEnabled = true
            return
        }
        
        let newTimerDuration = sender.selectedTag()
        customSlider.integerValue = newTimerDuration
        showSliderValuesAsText()
        customSlider.isEnabled = false
    }
    
    @IBAction func customEggTime(_ sender: NSSlider) {
        showSliderValuesAsText()
    }
    @IBAction func okClicked(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    @IBAction func cancelClicked(_ sender: Any) {
        view.window?.close()
    }
    
    func showExistingPrefs() {
        
        let selectedTimeInMinutes = Int(prefs.selectedTime) / 60
        //Set the defaults to "Custom" in case no matching preset value is found
        presetsPopupBtn.selectItem(withTitle: "Custom")
        customSlider.isEnabled = true
        
        for item in presetsPopupBtn.itemArray {
            if item.tag == selectedTimeInMinutes {
                presetsPopupBtn.select(item)
                customSlider.isEnabled = false
                break
            }
        }
        
        customSlider.integerValue = selectedTimeInMinutes
        showSliderValuesAsText()
    }
    
    func saveNewPrefs() {
        prefs.selectedTime = customSlider.doubleValue * 60
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"PrefsChanged"), object: nil)
    }
    
    func showSliderValuesAsText() {
        let newTimerDuration = customSlider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        customTimeLabel.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
}
