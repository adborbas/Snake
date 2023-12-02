//
//  SnakeSegmentConfiguration.swift
//  Snake
//
//  Created by Adam Borbas on 27/10/2023.
//

import Foundation
import SwiftUI

struct SnakeSegmentConfiguration {
    let direction: Direction
    let color: Color
    let size: CGFloat
    let padding: CGFloat
    
    var paddedSize: CGFloat {
        return size - padding * 2
    }
}
