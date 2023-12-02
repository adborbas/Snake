//
//  SnakeTailView.swift
//  Snake
//
//  Created by Adam Borbas on 22/10/2023.
//

import SwiftUI

struct SnakeTailView: SnakeSegmentView {
    let configuration: SnakeSegmentConfiguration
    
    var body: some View {
        RoundedCorners(radius: (configuration.paddedSize) / 2, corners: cornerRadius())
            .fill(configuration.color)
            .frame(width: width, height: height)
            .offset(offsetYolo)
    }
    
    private var offsetYolo: CGSize {
        switch configuration.direction {
        case .up, .down:
            return CGSize(width: configuration.padding, height: 0)
        case .left, .right:
            return CGSize(width: 0, height: configuration.padding)
        }
    }
    
    private func cornerRadius() -> UIRectCorner {
        switch configuration.direction {
        case .up:
            return [.bottomLeft, .bottomRight]
        case .down:
            return [.topLeft, .topRight]
        case .left:
            return [.bottomRight, .topRight]
        case .right:
            return [.bottomLeft, .topLeft]
        }
    }
    
    private var width: CGFloat {
        switch configuration.direction {
        case .left, .right: return configuration.size
        case .up, .down: return configuration.paddedSize
        }
    }
    
    private var height: CGFloat {
        switch configuration.direction {
        case .left, .right: return configuration.paddedSize
        case .up, .down: return configuration.size
        }
    }
}

#Preview {
    func config(with direction: Direction) -> SnakeSegmentConfiguration {
        return SnakeSegmentConfiguration(direction: direction, color: .green, size: 30, padding: 1.5)
    }
    
    return HStack {
        VStack {
            Text("Up")
            SnakeTailView(configuration: config(with: .up))
        }
        VStack {
            Text("Down")
            SnakeTailView(configuration: config(with: .down))
        }
        VStack {
            Text("Left")
            SnakeTailView(configuration: config(with: .left))
        }
        VStack {
            Text("Right")
            SnakeTailView(configuration: config(with: .right))
        }
    }
}
