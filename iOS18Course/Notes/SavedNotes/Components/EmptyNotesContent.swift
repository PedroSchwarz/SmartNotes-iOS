//
//  EmptyNotesContent.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI

struct EmptyNotesContent: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("No notes saved yet.")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Start by generating a note using AI or save your own. Your notes will appear here for easy access whenever you need them.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    EmptyNotesContent()
}
