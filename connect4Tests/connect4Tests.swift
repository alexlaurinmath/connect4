//
//  connect4Tests.swift
//  connect4Tests
//
//  Created by Alexandre Laurin on 1/5/18.
//  Copyright © 2018 Snacktime. All rights reserved.
//

import XCTest
@testable import connect4

class connect4Tests: XCTestCase {
    
    var testGameController:connect4GameController!
    var emptyPlayingField = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 7)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testGameController = connect4GameController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testGameController = nil
    }
    
    func testPlaceOneChipOnFirstColumn() {
        let currentPlayer = 1
        testGameController.currentPlayer = currentPlayer
        var singleChipPlayingField = emptyPlayingField
        testGameController.resetGame()
        singleChipPlayingField[0][5] = currentPlayer
        
        _ = testGameController.playChip(withColumn: 0)
        
        for columnNo in 0..<testGameController.playingField.count {
            for rowNo in 0..<testGameController.playingField[0].count {
                XCTAssertEqual(testGameController.playingField[columnNo][rowNo],singleChipPlayingField[columnNo][rowNo],"First chip is not placing correctly.")
            }
        }
    }
    
    func testPlaceTwoChipsOnFirstColumn() {
        let currentPlayer = 1
        testGameController.currentPlayer = currentPlayer
        var doubleChipPlayingField = emptyPlayingField
        testGameController.resetGame()
        doubleChipPlayingField[0][5] = currentPlayer
        doubleChipPlayingField[0][4] = 2
        
        _ = testGameController.playChip(withColumn: 0)
        _ = testGameController.playChip(withColumn: 0)
        
        for columnNo in 0..<testGameController.playingField.count {
            for rowNo in 0..<testGameController.playingField[0].count {
                XCTAssertEqual(testGameController.playingField[columnNo][rowNo],doubleChipPlayingField[columnNo][rowNo],"Second chip is not placing correctly for column \(columnNo) and row \(rowNo).")
            }
        }
    }
    
    func testPlaceChipInInexistingColumn() {
        testGameController.resetGame()
        _ = testGameController.playChip(withColumn: -1)
        _ = testGameController.playChip(withColumn: 7)
        
        for columnNo in 0..<testGameController.playingField.count {
            for rowNo in 0..<testGameController.playingField[0].count {
                XCTAssertEqual(testGameController.playingField[columnNo][rowNo], 0, "Second chip is not placing correctly for column \(columnNo) and row \(rowNo).")
            }
        }
    }
    
    func testFillUpColumn() {
        testGameController.resetGame()
        for _ in 0..<6 {
            _ = testGameController.playChip(withColumn: 0)
        }
        _ = testGameController.playChip(withColumn: 0)
        var fullColumnPlayingField = emptyPlayingField
        fullColumnPlayingField[0][5] = 1
        fullColumnPlayingField[0][4] = 2
        fullColumnPlayingField[0][3] = 1
        fullColumnPlayingField[0][2] = 2
        fullColumnPlayingField[0][1] = 1
        fullColumnPlayingField[0][0] = 2
        
        for columnNo in 0..<testGameController.playingField.count {
            for rowNo in 0..<testGameController.playingField[0].count {
                XCTAssertEqual(testGameController.playingField[columnNo][rowNo],fullColumnPlayingField[columnNo][rowNo],"Full column chip is not placing correctly for column \(columnNo) and row \(rowNo).")
            }
        }
    }
    
    func testSWNEWin() {
        testGameController.resetGame()
        testGameController.playingField[0][5] = 1
        testGameController.playingField[1][4] = 1
        testGameController.playingField[2][3] = 1
        testGameController.playingField[3][2] = 1
        testGameController.currentPlayer = 1
        
        var didWin = testGameController.checkForWinner(lastPosition: [0,5])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [1,4])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [3,2])
        XCTAssertTrue(didWin)
        
    }
    
    func testNWSEWin() {
        testGameController.resetGame()
        testGameController.playingField[0][2] = 1
        testGameController.playingField[1][3] = 1
        testGameController.playingField[2][4] = 1
        testGameController.playingField[3][5] = 1
        testGameController.currentPlayer = 1
        
        var didWin = testGameController.checkForWinner(lastPosition: [0,2])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [1,3])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [3,5])
        XCTAssertTrue(didWin)
        
    }
    
    func testRowWin() {
        testGameController.resetGame()
        testGameController.playingField[0][2] = 2
        testGameController.playingField[1][2] = 2
        testGameController.playingField[2][2] = 2
        testGameController.playingField[3][2] = 2
        testGameController.currentPlayer = 2
        
        var didWin = testGameController.checkForWinner(lastPosition: [0,2])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [1,2])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [3,2])
        XCTAssertTrue(didWin)
    }
    
    func testColumnWin() {
        testGameController.resetGame()
        testGameController.playingField[3][0] = 2
        testGameController.playingField[3][1] = 2
        testGameController.playingField[3][2] = 2
        testGameController.playingField[3][3] = 2
        testGameController.currentPlayer = 2
        
        var didWin = testGameController.checkForWinner(lastPosition: [3,0])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [3,2])
        XCTAssertTrue(didWin)
        didWin = testGameController.checkForWinner(lastPosition: [3,3])
        XCTAssertTrue(didWin)
    }
    
    func testIsInBoundary() {
        testGameController.resetGame()
        for columnNo in 0..<testGameController.playingField.count {
            for rowNo in 0..<testGameController.playingField[0].count {
                XCTAssertTrue(testGameController.isInBoundary(column: columnNo, row: rowNo))
            }
        }
        XCTAssertFalse(testGameController.isInBoundary(column: -1, row: -1))
        XCTAssertFalse(testGameController.isInBoundary(column: 0, row: 6))
        XCTAssertFalse(testGameController.isInBoundary(column: 7, row: 0))
    }
}
