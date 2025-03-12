//
//  ScrollToTopButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 9/3/2025.
//

import SwiftUI

struct ScrollToTopButton: View {
    let show: Bool
    let scrollToTop: () -> Void
    
    var body: some View {
        FloatingActionButton(
            action: scrollToTop,
            image: "chevron.up"
        )
        .padding(8)
        .offset(y: show ? 0 : 50)
        .opacity(show ? 1 : 0)
        .animation(.default, value: show)
    }
}

#Preview {
    ScrollToTopButton(show: false, scrollToTop: { })
}
