//
//  Circly.swift
//  WhiteMusicPlayer
//
//  Created by HanLiu on 2017/7/18.
//  Copyright © 2017年 HanLiu. All rights reserved.
//

import Cocoa

func degreeToRadian(_ degree: Int) -> Double {
    return Double(degree) * (Double.pi / 180)
}

func radianToDegree(_ radian: Double) -> Int {
    return Int(radian * (180 / Double.pi))
}

@IBDesignable
open class Circle: NSView {
    
    var circleBackgroundLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    
    @IBInspectable open var backgroundColor:NSColor = NSColor.gray
    @IBInspectable open var progressCircleStrokeColor:NSColor = NSColor.green
    @IBInspectable open var lineWidth:CGFloat = 8.0
    
    open var animated : Bool = true
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI() {
        self.wantsLayer = true//it's important
        addCircleBackgroundLayer()
        addProgressCricleLayer()
    }
    private func addCircleBackgroundLayer() {
        
        let rect = self.bounds
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let path = NSBezierPath()
        path.appendArc(withCenter: center, radius: center.x - lineWidth, startAngle: 0, endAngle: 360)
        
        circleBackgroundLayer.path = path.cgPath
        circleBackgroundLayer.lineWidth = lineWidth
        circleBackgroundLayer.strokeColor = backgroundColor.cgColor
        circleBackgroundLayer.lineCap = kCALineCapRound
        circleBackgroundLayer.fillColor = NSColor.clear.cgColor
        circleBackgroundLayer.frame = rect
        self.layer?.addSublayer(circleBackgroundLayer)
    }
    
    private func addProgressCricleLayer() {
        let rect = self.bounds
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let path = NSBezierPath()
        path.appendArc(withCenter: center, radius: center.x - lineWidth, startAngle: 90, endAngle: -270, clockwise:true)
        
        progressLayer.frame = rect
        progressLayer.strokeEnd = 0
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeColor = progressCircleStrokeColor.cgColor
        progressLayer.lineCap = kCALineCapRound
        progressLayer.fillColor = NSColor.clear.cgColor
        self.layer?.addSublayer(progressLayer)
    }
    
    func updateProgress() {
        //add new progress circle
        CATransaction.begin()
        if animated {
            CATransaction.setAnimationDuration(0.5)
        } else {
            CATransaction.setDisableActions(true)
        }
        let timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        CATransaction.setAnimationTimingFunction(timing)
        progressLayer.strokeEnd = max(0, min(progress, 1))
        CATransaction.commit()
        
    }
}

public extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement: path.move(to: points[0])
            case .lineToBezierPathElement: path.addLine(to: points[0])
            case .curveToBezierPathElement: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement: path.closeSubpath()
            }
        }
        return path
    }
    
}


