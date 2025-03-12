//
//  FullNoteContent.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI
import MarkdownUI

struct FullNoteContent: View {
    let content: String
    let closeNote: () -> Void
    
    var body: some View {
        ScrollView {
            Markdown(content)
                .markdownTheme(.fancy)
                .textSelection(.enabled)
                .multilineTextAlignment(.leading)
                .font(.system(.body, design: .serif))
                .padding(.vertical, 32)
                .padding(.horizontal)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = content
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    ShareLink(item: content) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } preview: {
                    Markdown(content)
                        .markdownTheme(.fancy)
                        .font(.system(.body, design: .serif))
                        .scaleEffect(0.5)
                }
        }
        .overlay(alignment: .topTrailing, content: {
            FloatingActionButton(
                action: { withAnimation(.spring()) { closeNote() } },
                image: "xmark",
                size: 16,
                innerPadding: 12
            )
            .padding(8)
        })
    }
}

#Preview {
    FullNoteContent(content: "", closeNote: { })
}
