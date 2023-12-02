//
//  SnakeView.swift
//  Snake
//
//  Created by Adam Borbas on 20/10/2023.
//

import SwiftUI

protocol SnakeSegmentView: View {}

struct SnakeConfiguration {
    let segmentSize: CGFloat
    let segmentPadding: CGFloat
    let snakeColor: Color
}

struct SnakeView: View {
    @Binding var snake: Snake
    let configuration: SnakeConfiguration
    
    @ViewBuilder
    func segmentView(for segment: SnakeSegment) -> some View {
        let config = SnakeSegmentConfiguration(direction: segment.direction,
                                               color: configuration.snakeColor,
                                               size: configuration.segmentSize,
                                               padding: configuration.segmentPadding)
        if segment == snake.head {
            SnakeHeadView(configuration: config)
        } else if segment == snake.tail {
            SnakeTailView(configuration: config)
        } else {
            SnakeBodyView(configuration: config,
                          previousDirection: segment.previousDirection!)
        }
        
//        ArrowView(direction: segment.direction)
//            .frame(width: configuration.segmentSize, height: configuration.segmentSize)
    }
    
    var body: some View {
        ForEach([snake.head] + snake.body + [snake.tail], id: \.self) { segment in
            segmentView(for: segment)
                .offset(x: CGFloat(segment.position.column) * configuration.segmentSize, y: CGFloat(segment.position.row) * configuration.segmentSize)
        }
    }
}

#Preview {
    ZStack(alignment: .topLeading) {
        SnakeView(snake:
                .constant(Snake(
                    head: SnakeSegment(position: Position(row: 0, column: 0),
                                       direction: .left),
                    tail: SnakeSegment(position: Position(row: -1, column: 1),
                                       direction: .down),
                    body: [SnakeSegment(position: Position(row: 0, column: 1),
                                        direction: .down,
                                        previousDirection: .left)])
                ),
                  configuration: SnakeConfiguration(segmentSize: 30,
                                                    segmentPadding: 1.5,
                                                    snakeColor: .green))
    }
}
