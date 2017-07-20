//
//  AppDelegate.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/15.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var startTimerMenuItem: NSMenuItem!
    @IBOutlet weak var stopTimerMenuItem: NSMenuItem!
    @IBOutlet weak var resetTimerMenuItem: NSMenuItem!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching")
        enableMenus(start: true, stop: false, reset: false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("applicationWillTerminate")
    }

    func enableMenus(start:Bool, stop:Bool, reset:Bool) {
        startTimerMenuItem.isEnabled = start
        stopTimerMenuItem.isEnabled  = stop
        resetTimerMenuItem.isEnabled = reset
    }
}

