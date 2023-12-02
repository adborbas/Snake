// MIT License
//
// Copyright (c) 2023 Adam Borbas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//
//  SnakeGameViewModel.swift
//  Snake
//

import SwiftUI
import Combine

class SnakeGameViewModel: ObservableObject {
    enum GameStatus: String {
        case initial = "Initial"
        case playing = "Playing"
        case win = "Win"
        case dead = "Dead"
    }
    
    private var game: SnakeGame
    
    @Published var snake: Snake
    @Published var food: Food
    
    var isPlaying: Bool {
        guard case .playing = game.state else {
            return false
        }
        return true
    }
    
    var canStart: Bool {
        guard case .initial = game.state else {
            return false
        }
        return true
    }
    
    var rowCount: Int {
        return game.rowCount
    }
    
    var columnCount: Int {
        return game.columnCount
    }
    
    var gameStatus: GameStatus {
        switch game.state {
        case .initial:
            return .initial
        case .playing:
            return .playing
        case .finishedSuccessfully:
            return .win
        case .finishedSnakeBitSelf:
            return .dead
        }
    }
    
    var status: String {
        switch game.state {
        case .initial:
            return "Tap to start! "
        case .playing(foodEaten: let foodEaten):
            return "\(foodEaten)"
        case .finishedSuccessfully(foodEaten: let foodEaten):
            return "Win! Score: \(foodEaten)"
        case .finishedSnakeBitSelf(foodEaten: let foodEaten):
            return "Dead 🐍! Score: \(foodEaten)"
        }
    }
    
    init(rowCount: Int, colCount: Int) {
        self.game = SnakeGame(rowCount: rowCount, columnCount: colCount)
        self.snake = game.snake
        self.food = game.food
        
        updateState()
    }
    
    /// Start a new game
    func startNewGame() {
        game.start()
        updateState()
    }
    
    func restart() {
        game = SnakeGame(rowCount: game.rowCount, columnCount: game.columnCount)
        updateState()
    }
    
    /// Update the snake's position based on the current direction
    func updateSnake() {
        game.updateSnake()
        updateState()
    }
    
    /// Update the direction based on the swipe gesture
    func updateDirection(from gesture: DragGesture.Value) {
        let isHorizontal = abs(gesture.translation.width) > abs(gesture.translation.height)
        
        if isHorizontal {
            // Horizontal swipe
            if gesture.translation.width > 0 {
                game.changeDirection(to: .right)
            } else {
                game.changeDirection(to: .left)
            }
        } else {
            // Vertical swipe
            if gesture.translation.height > 0 {
                game.changeDirection(to: .down)
            } else {
                game.changeDirection(to: .up)
            }
        }
    }
    
    private func updateState() {
        self.snake = game.snake
        self.food = game.food
    }
}
