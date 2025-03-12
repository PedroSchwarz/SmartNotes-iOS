//
//  PromptItem.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 12/3/2025.
//

import SwiftUI

struct PromptItem: View {
    let prompt: PromptEntity
    let selectItem: (PromptEntity) -> Void
    let isDisabled: Bool
    let isSelected: Bool
    let longPress: (PromptEntity?) -> Void
    let deleteItem: () -> Void
    let editItem: () -> Void
    
    var body: some View {
        Button(action: { selectItem(prompt) }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(prompt.title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(prompt.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: 160)
        .disabled(isDisabled)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected
                    ? Color.red.opacity(0.5)
                    : Color.primary.opacity(0.2),
                    lineWidth: 1
                )
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        )
        .tint(Color.primary)
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
            if isSelected {
                longPress(nil)
            } else {
                longPress(prompt)
            }
        }))
        .scaleEffect(isSelected ? 0.9 : 1)
        .animation(.spring, value: isSelected)
        .overlay(alignment: .topTrailing, content: {
            HStack(spacing: 8) {
                Button { editItem() } label: {
                    Image(systemName: "pencil.tip.crop.circle")
                }
                .tint(.blue)
                
                Divider()
                    .frame(height: 16)
                
                Button { deleteItem() } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.red)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
            .offset(y: -7)
            .opacity(isSelected ? 1 : 0)
            .animation(.spring, value: isSelected)
        })
    }
}

#Preview {
    PromptItem(
        prompt: .init(title: "Test Prompt", subtitle: "This is a test prompt", content: "Lorem ipsum", timestamp: .now, order: 1),
        selectItem: { _ in },
        isDisabled: false,
        isSelected: false,
        longPress: { _ in },
        deleteItem: { },
        editItem: { }
    )
}
