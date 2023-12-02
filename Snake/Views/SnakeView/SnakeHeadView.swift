//
//  SnakeHeadView.swift
//  Snake
//
//  Created by Adam Borbas on 22/10/2023.
//

import SwiftUI

struct SnakeHeadView: SnakeSegmentView {
    let configuration: SnakeSegmentConfiguration
    
    var body: some View {
        ZStack {
            // Base shape for the snake's head
            RoundedCorners(radius: configuration.paddedSize / 2, corners: cornerRadius())
                .fill(configuration.color)
                .frame(width: width, height: height)
                .offset(offset)
            
            // Eye for the snake's head
            Circle()
                .fill(Color.black)
                .frame(width: configuration.size / 8, height: configuration.size / 8)
                .offset(x: configuration.size / 4, y: -configuration.size / 4)
                .rotationEffect( .degrees(eyeRotation), anchor: .center)
            
            tonguePath
                .stroke(Color.red, lineWidth: 1)
                .frame(width: width, height: height)
                .rotationEffect( .degrees(tongueRotation), anchor: .center)
        }
    }
    
    private var offset: CGSize {
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
            return [.topLeft, .topRight]
        case .down:
            return [.bottomLeft, .bottomRight]
        case .left:
            return [.bottomLeft, .topLeft]
        case .right:
            return [.bottomRight, .topRight]
        }
    }
    
    private var eyeRotation: Double {
        switch configuration.direction {
        case .up:
            return 0
        case .down:
            return 180
        case .left:
            return -90
        case .right:
            return 0
        }
    }
    
    private var tonguePath: Path {
        var path = Path()
        path.move(to: CGPoint(x: configuration.size / 2, y: 0))
        path.addCurve(
            to: CGPoint(x: configuration.size / 2, y: 10),
            control1: CGPoint(x: configuration.size / 2 - 5, y: 5),
            control2: CGPoint(x: configuration.size / 2 + 5, y: 5)
        )
        return path
    }
    
    private var tongueRotation: Double {
        switch configuration.direction {
        case .up:
            return 0
        case .down:
            return 180
        case .left:
            return -90
        case .right:
            return 90
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
            SnakeHeadView(configuration: config(with: .up))
        }
        VStack {
            Text("Down")
            SnakeHeadView(configuration: config(with: .down))
        }
        VStack {
            Text("Left")
            SnakeHeadView(configuration: config(with: .left))
        }
        VStack {
            Text("Right")
            SnakeHeadView(configuration: config(with: .right))
        }
    }
}
