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
//  GameBoard.swift
//  Snake
//

import SwiftUI

struct GameBoardConfiguration {
    let rowCount: Int
    let columnCount: Int
    let cellSize: CGFloat
    let color: Color
}

struct GameBoardView: View {
    let configuration: GameBoardConfiguration
    
    var body: some View {
        RoundedRectangle(cornerRadius: configuration.cellSize / 8)
            .fill(configuration.color)
            .overlay(
                RoundedRectangle(cornerRadius:  configuration.cellSize / 8)
                    .stroke(.black, lineWidth: 2)
            )
            .frame(width: CGFloat(configuration.columnCount) * configuration.cellSize,
                   height: CGFloat(configuration.rowCount) * configuration.cellSize)
    }
}

#Preview {
    ZStack {
        GameBoardView(configuration: GameBoardConfiguration(rowCount: 5,
                                                            columnCount: 5,
                                                            cellSize: 30,
                                                            color: .gray))
    }
}
