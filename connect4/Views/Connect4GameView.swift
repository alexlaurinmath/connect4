//
//  Connect4GameView.swift
//  connect4
//
//  Created by Alexandre Laurin on 1/7/18.
//  Copyright © 2018 Snacktime. All rights reserved.
//

import UIKit
import AVFoundation

class connect4GameView: UIView {
    
    let numColumns:Int = 7
    let numRows:Int = 6
    let buttonBuffer:CGFloat = 10
    var columnWidth:CGFloat = 0.0
    let lineWidth:CGFloat = 2
    let startHeight:CGFloat = 140.0
    
    var circles:[CAShapeLayer] = []
    let playerColors = [Red1, Yellow1]
    
    var player: AVAudioPlayer?

    override func draw(_ rect: CGRect) {
        columnWidth = (self.bounds.width - 0.5*buttonBuffer)/CGFloat(numColumns)
        let linePath = createGrid()
        linePath.stroke()
    }

    
    private func createGrid() -> UIBezierPath {
        let linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        for i in 0..<numRows + 1 {
            linePath.move(to: CGPoint(x: 0.25*buttonBuffer , y: startHeight + CGFloat(i)*columnWidth))
            linePath.addLine(to: CGPoint(x: self.bounds.width - 0.25*buttonBuffer , y: startHeight + CGFloat(i)*columnWidth))
        }
        for i in 0..<numColumns + 1 {
            linePath.move(to: CGPoint(x: 0.25*buttonBuffer + CGFloat(i)*columnWidth , y: startHeight))
            linePath.addLine(to: CGPoint(x: 0.25*buttonBuffer + CGFloat(i)*columnWidth , y: startHeight + CGFloat(numRows)*columnWidth))
        }
        Grey1.setStroke()
        
        return linePath
    }
    
    func placeChipCircle(atPosition:[Int], fromPlayer:Int) {
        guard atPosition.count == 2 else {
            return
        }
        guard atPosition[0] >= 0, atPosition[0] < numColumns, atPosition[1] >= 0, atPosition[1] < numRows else {
            return
        }
        
        let circleRadius:CGFloat = columnWidth*0.4
        let xCenter:CGFloat = 0.25*buttonBuffer + CGFloat(atPosition[0])*columnWidth + 0.5*columnWidth
        let yCenterStart:CGFloat = startHeight
        let centerPointStart = CGPoint(x: xCenter, y: yCenterStart)
        
        let circlePath = UIBezierPath(arcCenter: centerPointStart, radius: circleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.path = circlePath.cgPath
        
        if fromPlayer <= playerColors.count {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.playChipSound()
            })
            let animation = CABasicAnimation(keyPath: "position")
            animation.toValue = CGPoint(x: circleShapeLayer.position.x, y: circleShapeLayer.position.y + CGFloat(atPosition[1])*columnWidth + 0.5*columnWidth)
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            
            
            let chipColor = playerColors[fromPlayer - 1]
            circleShapeLayer.fillColor = chipColor.cgColor
            circleShapeLayer.strokeColor = chipColor.cgColor
            self.circles.append(circleShapeLayer)
            
            self.layer.addSublayer(circleShapeLayer)
            circleShapeLayer.add(animation, forKey: animation.keyPath)
            CATransaction.commit()
        }
    }
    
    func clearAllCircles() {
        for layer in self.circles {
            layer.removeFromSuperlayer()
        }
        self.circles.removeAll()
    }
    
    func playChipSound() {
        guard let url = Bundle.main.url(forResource: "Impact", withExtension: "wav") else {
            print("Error. Could not find chip sound file.")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
