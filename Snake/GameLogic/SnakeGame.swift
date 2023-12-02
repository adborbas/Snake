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
//  SnakeGame.swift
//  Snake
//

class SnakeGame {
    enum State {
        case initial
        case playing(foodEaten: Int)
        case finishedSuccessfully(foodEaten: Int)
        case finishedSnakeBitSelf(foodEaten: Int)
    }
    
    // Dimensions
    let rowCount: Int
    let columnCount: Int
    
    // Snake's initial position
    var snake = {
        return Snake(head: SnakeSegment(position: Position(row: 0, column: 0), direction: .down),
                     tail: SnakeSegment(position: Position(row: 0, column: 1), direction: .down),
                     body: [])
    }()
    
    // Food position
    var food = Food(position: Position(row: 0, column: 0))
    private var directionQueue = [Direction]()
    var direction: Direction = .down
    
    private(set) var state: State = .initial
    
    init(rowCount: Int, columnCount: Int) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        
        // Initialize the game state
        initializeGameState()
    }
    
    func start() {
        state = .playing(foodEaten: 0)
        updateSnake()
    }
    
    func updateSnake() {
        guard case .playing(let foodEaten) = state else {
            return
        }
        
        // Dequeue the next direction and apply it
        if !directionQueue.isEmpty {
            direction = directionQueue.removeFirst()
        }
        
        let newHeadPosition = calculateNewHeadPosition()
        var newSnake = snake.snakeByMovingHead(to: newHeadPosition, with: direction)
        
        // Check if newSnake collides with itself
        if newSnake.isBitingItself {
            state = .finishedSnakeBitSelf(foodEaten: foodEaten)
            return
        }
        
        if isSnakeHittingWall() {
            state = .finishedSnakeBitSelf(foodEaten: foodEaten)
            return
        }
        
        // Check if newSnake head collides with food
        if newSnake.head.position == food.position {
            state = .playing(foodEaten: foodEaten + 1)
            newSnake = snake.snakeByEatingFood(at: food.position, with: direction)
            randomizeFood(for: newSnake)
        }
        
        snake = newSnake
    }
    
    private func isSnakeHittingWall() -> Bool {
        let position = snake.head.position
        return position.row == 0 && direction == .up || position.row == rowCount - 1 && direction == .down ||
        position.column == 0 && direction == .left || position.column == columnCount - 1 && direction == .right
    }
    
    /// Calculate new head position based on the current direction
    private func calculateNewHeadPosition() -> Position {
        let headPosition = snake.head.position
        var newRow = headPosition.row
        var newColumn = headPosition.column
        
        switch direction {
        case .up:
            newRow = (headPosition.row - 1 + rowCount) % rowCount
        case .down:
            newRow = (headPosition.row + 1) % rowCount
        case .left:
            newColumn = (headPosition.column - 1 + columnCount) % columnCount
        case .right:
            newColumn = (headPosition.column + 1) % columnCount
        }
        
        return Position(row: newRow, column: newColumn)
    }
    
    /// Initialize the game state to initial values
    private func initializeGameState() {
        let initialHead = SnakeSegment(position: Position(row: 5, column: 5), direction: .down)
        let initialTail = SnakeSegment(position: Position(row: 4, column: 5), direction: .down)
        
        self.snake = Snake(head: initialHead, tail: initialTail, body: [])
        
        self.snake = Snake(head: initialHead, tail: initialTail, body: [])
        self.food = Food(position: Position(row: 0, column: 0))
        self.direction = .down
        self.state = .initial
        
        randomizeFood(for: self.snake)
    }
    
    /// Randomize the food position
    func randomizeFood(for snake: Snake) {
        var availablePositions = Set<Position>()
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                let position = Position(row: row, column: column)
                if !snake.body.contains(where: { $0.position == position }) &&
                   snake.head.position != position &&
                   snake.tail.position != position {
                    availablePositions.insert(position)
                }
            }
        }
        
        // If there's no available position, finish the game successfully
        if availablePositions.isEmpty {
            if case .playing(let foodEaten) = state {
                state = .finishedSuccessfully(foodEaten: foodEaten)
            }
            return
        }

        let newFoodPosition = availablePositions.randomElement()!
        food = Food(position: newFoodPosition)
    }
    
    /// Change the direction
    func changeDirection(to newDirection: Direction) {
        guard case .playing = state else {
            return
        }

        if !direction.isOpposite(of: newDirection) {
            directionQueue.append(newDirection)
        }
    }

    /// Start the game
    func startGame() {
        state = .playing(foodEaten: 0)
    }
    
    /// Finish the game successfully
    func finishGameSuccessfully() {
        if case .playing(let foodEaten) = state {
            state = .finishedSuccessfully(foodEaten: foodEaten)
        }
    }
}
