//
//  Cardified.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import SwiftUI

struct CardifiedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 8)
    }
}

extension View {
    func cardified() -> some View {
        self.modifier(CardifiedModifier())
    }
}
