//
//  SnakeBodyView.swift
//  Snake
//
//  Created by Adam Borbas on 22/10/2023.
//

import SwiftUI

struct SnakeBodyView: SnakeSegmentView {
    let configuration: SnakeSegmentConfiguration
    let previousDirection: Direction
    
    var body: some View {
        if previousDirection != configuration.direction {
            cornerPath
                .fill(configuration.color)
                .frame(width: configuration.size, height: configuration.size)
                .rotationEffect(.degrees(cornerRotation), anchor: .center)
        } else {
            straightBodyPath
                .fill(configuration.color)
                .frame(width: configuration.size, height: configuration.size)
                .rotationEffect(.degrees(straightBodyRotation), anchor: .center)
        }
    }
    
    private var straightBodyPath: Path {
        var path = Path()
        path.move(to: CGPoint(x: configuration.padding, y: 0))
        path.addLine(to: CGPoint(x: configuration.size - configuration.padding, y: 0))
        path.addLine(to: CGPoint(x: configuration.size - configuration.padding, y: configuration.size))
        path.addLine(to: CGPoint(x: configuration.padding, y: configuration.size))
        path.addLine(to: CGPoint(x: configuration.padding, y: 0))
        return path
    }
    
    private var straightBodyRotation: Double {
        switch configuration.direction {
        case .up, .down:
            return 0
        case .left, .right:
            return 90
        }
    }
    
    private var cornerPath: Path {
        var path = Path()
        path.move(to: CGPoint(x: configuration.padding, y: 0))
        path.addLine(to: CGPoint(x: configuration.size - configuration.padding, y: 0))
        path.addLine(to: CGPoint(x: configuration.size - configuration.padding, y: (configuration.size - configuration.padding) / 2))
        path.addCurve(to:  CGPoint(x: (configuration.size - configuration.padding) / 2, y: configuration.size - configuration.padding),
                      control1: CGPoint(x: configuration.size - configuration.padding, y: (configuration.size - configuration.padding) / 2),
                      control2: CGPoint(x: configuration.size - configuration.padding, y: configuration.size - configuration.padding))
        path.addLine(to: CGPoint(x: 0, y: configuration.size - configuration.padding))
        path.addLine(to: CGPoint(x: 0, y: configuration.padding))
        
        path.addCurve(to:  CGPoint(x: configuration.padding, y: 0),
                      control1: CGPoint(x: 0, y: configuration.padding),
                      control2: CGPoint(x: configuration.padding, y:  configuration.padding))
        return path
    }
    
    private var cornerRotation: Double {
        switch (configuration.direction, previousDirection) {
        case (.down, .right), (.left, .up):
            return 90
        case (.up, .right), (.left, .down):
            return 180
        case (.right, .down), (.up, .left):
            return -90
        case (.right, .up), (.down, .left):
            return 0
        case (let direction, let previousDirection):
            assertionFailure("Invalid direction combination. direction: \(direction), previousDirection: \(previousDirection)")
            return 0
        }
    }
}

#Preview {
    func config(with direction: Direction) -> SnakeSegmentConfiguration {
        return SnakeSegmentConfiguration(direction: direction, color: .green, size: 30, padding: 1.5)
    }
    
    return VStack {
        HStack {
            VStack {
                Text("Up")
                VStack(spacing: 0) {
                    SnakeBodyView(configuration: config(with: .up), previousDirection: .up)
                    SnakeBodyView(configuration: config(with: .up), previousDirection: .up)
                }.background(.red)
            }
            VStack {
                Text("Down")
                VStack(spacing: 0) {
                    SnakeBodyView(configuration: config(with: .down), previousDirection: .down)
                    SnakeBodyView(configuration: config(with: .down), previousDirection: .down)
                }.background(.red)
            }
            VStack {
                Text("Left")
                HStack(spacing: 0) {
                    SnakeBodyView(configuration: config(with: .left), previousDirection: .left)
                    SnakeBodyView(configuration: config(with: .left), previousDirection: .left)
                }.background(.red)
            }
            VStack {
                Text("Right")
                HStack(spacing: 0) {
                    SnakeBodyView(configuration: config(with: .right), previousDirection: .right)
                    SnakeBodyView(configuration: config(with: .right), previousDirection: .right)
                }.background(.red)
            }
        }
        HStack {
            VStack {
                Text("↓ - →")
                SnakeBodyView(configuration: config(with: .down), previousDirection: .right)
                Text("← - ↑")
                SnakeBodyView(configuration: config(with: .left), previousDirection: .up)
            }.background(.red)
            VStack {
                Text("↑ - →")
                SnakeBodyView(configuration: config(with: .up), previousDirection: .right)
                Text("← - ↓")
                SnakeBodyView(configuration: config(with: .left), previousDirection: .down)
            }.background(.red)
            VStack {
                Text("→ - ↓")
                SnakeBodyView(configuration: config(with: .right), previousDirection: .down)
                Text("↑ - ←")
                SnakeBodyView(configuration: config(with: .up), previousDirection: .left)
            }.background(.red)
            VStack {
                Text("→ - ↑")
                SnakeBodyView(configuration: config(with: .right), previousDirection: .up)
                Text("↓ - ←")
                SnakeBodyView(configuration: config(with: .down), previousDirection: .left)
            }.background(.red)
        }
    }
}
