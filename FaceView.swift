//
//  FaceView.swift
//  FaceIt
//
//  Created by JungHyesu on 2016. 10. 2..
//  Copyright © 2016년 nomadc. All rights reserved.
//  한글링 아이오에스 4강 얼굴앱을 만들며 뷰를 알자 실습

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.90
    
    var mouthCurvature: Double = 1.0 //1 full sime -1 fill frown

    var skullRadius:CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeOffRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        
        
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenterdAtPoint(minPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: minPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = 5.0
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        var eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForeye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeOffRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        return pathForCircleCenterdAtPoint(minPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let moutHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: moutHeight)
        
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        //Swift 3.0 함수명이 변경됨
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    //Swift 3.0 함수이 변경됨
    override func draw(_ rect: CGRect) {
        
        //Swift3.0 UIColor property명 변경
//        UIColor.blue.set()
        UIColor.black.set()
        pathForCircleCenterdAtPoint(minPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForeye(eye: .Left).stroke()
        pathForeye(eye: .Right).stroke()
        pathForMouth().stroke()

    }
 

}
