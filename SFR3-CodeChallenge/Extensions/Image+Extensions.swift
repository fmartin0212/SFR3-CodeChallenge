//
//  Image+Extensions.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation
import SwiftUI
import UIKit

extension Image {
    static func named(_ name: UIImage.SystemName) -> Image {
        Image(systemName: name.rawValue)
    }
}

extension UIImage {
    enum SystemName: String, CaseIterable {
        case heart
        case heartFill = "heart.fill"
        case forkKnife = "fork.knife"
        case exclamationmarkCircleFill = "exclamationmark.circle.fill"
    }
    
    static func named(_ name: SystemName) -> UIImage {
        UIImage(systemName: name.rawValue) ?? UIImage()
    }
}

