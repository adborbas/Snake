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
//  ContentView.swift
//  Snake
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SnakeGameViewModel
    
    private let snakeConfiguration = SnakeConfiguration(segmentSize: 30.0,
                                                        segmentPadding: 1.5,
                                                        snakeColor: .yellow)
    
    var body: some View {
        VStack {
            Text("\(viewModel.status)")
                .font(.title)
            ZStack(alignment: .topLeading) {
                GameBoardView(configuration: GameBoardConfiguration(rowCount: viewModel.rowCount,
                                                                    columnCount: viewModel.columnCount,
                                                                    cellSize: snakeConfiguration.segmentSize,
                                                                    color: .green))
                SnakeView(snake: $viewModel.snake, configuration: snakeConfiguration)
                FoodView(food: $viewModel.food, size: snakeConfiguration.segmentSize)
            }
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded({ value in
                        viewModel.updateDirection(from: value)
                    })
            )
            .onTapGesture {
                switch viewModel.gameStatus {
                case .initial:
                    viewModel.startNewGame()
                case .win, .dead:
                    viewModel.restart()
                case .playing:
                    break
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.26, repeats: true) { _ in
                    viewModel.updateSnake()
                }
            }
        }
    }
}

#Preview {
    ContentView(viewModel: SnakeGameViewModel(rowCount: 13, colCount: 13))
}
