//
//  Preferences.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/17.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Foundation

struct Preferences {
    var selectedTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            return 360
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
}

class Woo {
    lazy var lazyProperty  = " lazy property"
    var storedProperty : String = "hh" {
        didSet {
            
        }
    }
}
