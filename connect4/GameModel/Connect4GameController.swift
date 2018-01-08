//
//  GameController.swift
//  connect4
//
//  Created by Alexandre Laurin on 1/5/18.
//  Copyright © 2018 Snacktime. All rights reserved.
//

import Foundation

class connect4GameController {
    
    var playingField = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 7)
    var currentPlayer:Int = 1
    
    var directions = [[-1, 1], [0, 1], [1, 1], [1, 0]]
    
    func playChip(withColumn:Int) -> (Bool, [Int], Int) {
        
        var didWin = false
        
        guard withColumn >= 0, withColumn < 7 else {
            print("Column \(withColumn) does not exist.")
            return (didWin, [-1, -1], -1)
        }
        
        let column = playingField[withColumn]
        guard column.reduce(1, *) == 0  else {
            print("Column \(withColumn) is full.")
            return (didWin, [-1, -1], -1)
        }
        
        for rowNumber in 0..<column.count {
            // check for what is below the chip
            let lastPlayer = currentPlayer
            if column[rowNumber] > 0 || rowNumber == column.count - 1 {
                // either reached a chip or reached the bottom
                var playLocation = [Int] (repeating: -1, count: 2)
                if column[rowNumber] > 0 {
                    playingField[withColumn][rowNumber - 1] = currentPlayer
                    playLocation = [withColumn, rowNumber - 1]
                } else {
                    playingField[withColumn][rowNumber] = currentPlayer
                    playLocation = [withColumn, rowNumber]
                }
                if playLocation[0]>=0,  playLocation[1]>=0 {
                    didWin = checkForWinner(lastPosition: playLocation)
                    
                    if currentPlayer == 1 {
                        currentPlayer = 2
                    } else {
                        currentPlayer = 1
                    }
                }
                return (didWin, playLocation, lastPlayer)
            }
        }
        return (didWin, [-1, -1], -1)
    }
    
    func checkForWinner(lastPosition: [Int]) -> Bool {
        for direction in directions {
            // check in positive orientation
            let samePlayerChipCounterPositive = checkInOrientation(initPosition:lastPosition, direction:direction, orientation: 1)
            if samePlayerChipCounterPositive == 4 {
                return true
            }
            
            // check in negative orientation
            let samePlayerChipCounterNegative = checkInOrientation(initPosition:lastPosition, direction:direction, orientation: -1)
            
            if samePlayerChipCounterPositive + samePlayerChipCounterNegative - 1 == 4 {
                return true
            }
        }
        return false
    }
    
    func checkInOrientation(initPosition:[Int], direction:[Int], orientation: Int) -> Int {
        var samePlayerChipCounter:Int = 0
        var directionStep:Int = 0
        var xIncrement = direction[0]*directionStep
        var yIncrement = direction[1]*directionStep
        var checkValue = playingField[initPosition[0] + xIncrement][initPosition[1] + yIncrement]
        
        while isInBoundary(column: initPosition[0] + xIncrement, row: initPosition[1] + yIncrement) && samePlayerChipCounter < 4 && checkValue  == currentPlayer {
            samePlayerChipCounter += 1
            directionStep += orientation
            xIncrement = direction[0]*directionStep
            yIncrement = direction[1]*directionStep
            if isInBoundary(column: initPosition[0] + xIncrement, row: initPosition[1] + yIncrement) {
                checkValue = playingField[initPosition[0] + xIncrement][initPosition[1] + yIncrement]
            }
            
        }
        
        return samePlayerChipCounter
    }
    
    func resetGame() {
        self.playingField = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 7)
        currentPlayer = 1
    }
    
    func isInBoundary(column:Int, row:Int) -> Bool {
        guard playingField.count > 0 else {
            return false
        }
        guard playingField[0].count > 0 else {
            return false
        }
        guard column >= 0, row >= 0, column < playingField.count, row < playingField[0].count else {
            return false
        }
        return true
    }
}
