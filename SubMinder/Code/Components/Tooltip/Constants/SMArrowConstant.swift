//
//  ATArrowConstant.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 10/7/24.
//

import SwiftUI

/// The definition of arrow indication.
public struct SMArrowConstant: Equatable {
    
    public var width: CGFloat
    public var height: CGFloat
    
    /// Initializes `ATArrowConstant`
    /// - Parameters:
    ///   - width: The width of the arrow. The default value is `10`.
    ///   - height: The height of the arrow. The default value is `10`.
    public init(width: CGFloat = 10, height: CGFloat = 10) {
        self.width = width
        self.height = height
    }
}
