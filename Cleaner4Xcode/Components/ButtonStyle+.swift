//
//  ButtonStyle+.swift
//  Cleaner for Xcode
//
//  Created by Roger on 2026/3/4.
//  Copyright © 2026 Roger. All rights reserved.
//

import SwiftUI

public struct NoAnimationButtonStyle: ButtonStyle {

    public init() {}

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }

}

extension ButtonStyle where Self == NoAnimationButtonStyle {
    static var noAnimation: NoAnimationButtonStyle { NoAnimationButtonStyle() }
}
