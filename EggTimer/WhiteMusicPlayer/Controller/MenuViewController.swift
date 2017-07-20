//
//  ViewController.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/15.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {

    @IBOutlet var menuView: NSView!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var resultLabel: NSTextField!
    
    @IBOutlet weak var sayHelloBtn: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func sayHello(_ sender: Any) {
        var name = textField.stringValue
        if name.isEmpty {
            name = "World"
        }
        
        let greeting = "Hello \(name)"
        resultLabel.stringValue = greeting
    }
    
}

