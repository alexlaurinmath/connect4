//
//  ViewController.swift
//  connect4
//
//  Created by Alexandre Laurin on 1/5/18.
//  Copyright © 2018 Snacktime. All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

class ViewController: UIViewController {
    
    private var gameView:connect4GameView!
    private var winView = UIView()
    private var buttonArray: [UIButton] = []
    private var resetButton = UIButton()
    
    let gameController = connect4GameController()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeGameView()
        placeResetButton()
        createAllChipButtons()
        
    }
    
    private func placeGameView() {
        gameView = connect4GameView(frame: CGRect(x: 0, y: 0, width:self.view.bounds.width, height: self.view.bounds.height))
        gameView.backgroundColor = Background1
        self.view.addSubview(gameView)
    }
    
    private func placeResetButton() {
        let resetButtonHeight:CGFloat = 40
        let resetButtonBuffer:CGFloat = 10
        self.resetButton.frame = CGRect(x: resetButtonBuffer, y: self.view.bounds.height - resetButtonBuffer - resetButtonHeight, width: self.view.bounds.width - 2*resetButtonBuffer, height: resetButtonHeight)
        resetButton.backgroundColor = Purple1
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        
        self.gameView.addSubview(resetButton)
    }
    
    @objc func resetButtonAction(sender: Any?) {
        self.gameController.resetGame()
        self.gameView.clearAllCircles()
        self.winView.removeFromSuperview()
        self.turnOnButtons()
    }
    
    private func createAllChipButtons() {
        // place 7 buttons on top
        let numButtons = 7
        let buttonBuffer:CGFloat = 10
        let buttonWidth = self.view.bounds.width/CGFloat(numButtons) - buttonBuffer
        let buttonHeight:CGFloat = 40
        for i in 0..<numButtons {
            let button = UIButton(frame: CGRect(x: CGFloat(i)*buttonWidth + CGFloat(i)*buttonBuffer + 0.5*buttonBuffer, y: 6*buttonBuffer, width: buttonWidth, height: buttonHeight))
            button.tag = i
            button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
            self.buttonArray.append(button)
        }
        
        for button in self.buttonArray {
            self.gameView.addSubview(button)
        }
        turnOnButtons()
    }
    
    @objc func playButtonAction(sender: UIButton) {
        turnOffButtons()
        let (didWin, chipPosition, playerNumber) = gameController.playChip(withColumn: sender.tag)
        self.gameView.placeChipCircle(atPosition: chipPosition, fromPlayer: playerNumber)
        if didWin {
            self.gameIsWon(byPlayer: playerNumber)
        } else {
            turnOnButtons()
        }
    }
    
    private func gameIsWon(byPlayer: Int) {
        placeWinView()
        placeWinLabel(forPlayer: byPlayer)
        turnOffButtons()
        animateWinView()
    }
    
    private func placeWinView() {
        let winViewWidth = self.gameView.bounds.width - 20
        winView.frame = CGRect(x: self.gameView.center.x - winViewWidth/2, y: self.gameView.bounds.height, width: winViewWidth, height: winViewWidth)
        winView.backgroundColor = Purple1
        for subview in winView.subviews {
            subview.removeFromSuperview()
        }
        self.gameView.addSubview(winView)
    }
    
    private func placeWinLabel(forPlayer: Int) {
        let winLabelWidth:CGFloat = self.gameView.bounds.width - 40
        let winLabel = UILabel()
        winLabel.frame = CGRect(x: self.winView.center.x - winLabelWidth/2, y: self.winView.bounds.height/2 , width: winLabelWidth, height: 20)
        winLabel.text = "Player \(forPlayer) won!"
        winLabel.backgroundColor = UIColor.clear
        winLabel.textColor = Background1
        winLabel.textAlignment = .center
        self.winView.addSubview(winLabel)
    }
    
    private func animateWinView() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.winView.center.y = self.gameView.center.y
        }, completion: { finished in
            self.playWinSound()
        })
    }
    
    private func turnOffButtons() {
        
        for button in buttonArray {
            button.backgroundColor = Purple1
            button.isEnabled = false
        }
    }
    
    private func turnOnButtons() {
        
        for button in buttonArray {
            button.isEnabled = true
            button.backgroundColor = self.gameView.playerColors[self.gameController.currentPlayer - 1]
        }
    }
    
    func playWinSound() {
        guard let url = Bundle.main.url(forResource: "Win", withExtension: "mp3") else {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

