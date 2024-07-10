//
//  ATConstant.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 10/7/24.
//

import SwiftUI

/// The position mode of the tooltip.
public enum SMAxisMode: Sendable {
    case top
    case bottom
    case leading
    case trailing
}

/// Defines the settings for the tooltip.
public struct SMConstant: Equatable {
    
    public var axisMode: SMAxisMode
    public var border: SMBorderConstant
    public var arrow: SMArrowConstant
    public var shadow: SMShadowConstant
    public var distance: CGFloat
    public var animation: Animation?
    
    /// Initializes `ATConstant`
    /// - Parameters:
    ///   - axisMode: The position mode of the tooltip.
    ///   - border: The definition of a border.
    ///   - arrow: The definition of arrow indication.
    ///   - shadow: Defines the shadow of the tooltip.
    ///   - distance: The distance between the view and the tooltip. The default value is `8`.
    ///   - animation: An animation of the tooltip. The default value is `.easeInOut(duration: 0.28)`.
    public init(axisMode: SMAxisMode = .bottom,
                border: SMBorderConstant = .init(),
                arrow: SMArrowConstant = .init(),
                shadow: SMShadowConstant = .init(),
                distance: CGFloat = 8,
                animation: Animation? = .easeInOut(duration: 0.28)) {
        self.axisMode = axisMode
        self.border = border
        self.arrow = arrow
        self.shadow = shadow
        self.distance = distance
        self.animation = animation
    }
}
