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
//  Snake.swift
//  Snake
//

import Foundation

struct Snake: Equatable {
    let head: SnakeSegment
    let tail: SnakeSegment
    let body: [SnakeSegment]
    
    var isBitingItself: Bool {
        return body.contains { segment in
            segment.position == head.position
        } || tail.position == head.position
    }
    
    init(head: SnakeSegment, tail: SnakeSegment, body: [SnakeSegment]) {
        self.head = head
        self.tail = tail
        self.body = body
    }
    
    func snakeByMovingHead(to position: Position, with direction: Direction) -> Snake {
        var newBody = [SnakeSegment(position: head.position, direction: head.direction, previousDirection: direction)]
        for (index, segment) in body.enumerated() {
            let previousDirection = index == 0 ? head.direction : body[index - 1].direction
            newBody.append(SnakeSegment(position: segment.position, direction: segment.direction, previousDirection: previousDirection))
        }
        newBody.removeLast()
        
        var tailDirection: Direction = .down
        let lastSegmentPosition = newBody.last?.position ?? position
        let tailPosition = body.last?.position ?? head.position
        
        if tailPosition.row < lastSegmentPosition.row {
            tailDirection = .down
        } else if tailPosition.row > lastSegmentPosition.row {
            tailDirection = .up
        } else if tailPosition.column < lastSegmentPosition.column {
            tailDirection = .right
        } else if tailPosition.column > lastSegmentPosition.column {
            tailDirection = .left
        }
        
        let newTail = SnakeSegment(position: body.last?.position ?? head.position, direction: tailDirection, previousDirection: tail.direction)
        
        return Snake(
            head: SnakeSegment(position: position, direction: direction),
            tail: newTail,
            body: newBody
        )
    }
    
    func snakeByEatingFood(at position: Position, with direction: Direction) -> Snake {
        var newBody = [SnakeSegment(position: head.position, direction: head.direction, previousDirection: direction)]
        for (index, segment) in body.enumerated() {
            let previousDirection = index == 0 ? head.direction : body[index - 1].direction
            newBody.append(SnakeSegment(position: segment.position, direction: segment.direction, previousDirection: previousDirection))
        }
        
        return Snake(
            head: SnakeSegment(position: position, direction: direction),
            tail: tail,
            body: newBody
        )
    }
}
