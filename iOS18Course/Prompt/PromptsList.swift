//
//  PromptsList.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 25/2/2025.
//

import SwiftUI

struct PromptsList: View {
    let onSelect: (PromptTemplate) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(presetPrompts) { prompt in
                    Button(action: { onSelect(prompt) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(prompt.title)
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text(prompt.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                    )
                    .tint(Color.primary)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    PromptsList { _ in }
}
