//
//  GeneratedNoteCard.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI
import MarkdownUI

struct GeneratedNote: View {
    let notes: String
    let showNoteOptions: Bool
    let summarize: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Generated Notes")
                .font(.headline)
                .padding(.top)
            
            Markdown(notes)
                .markdownTheme(.fancy)
                .font(.system(.body, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = notes
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    ShareLink(item: notes) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Button { summarize() } label: {
                        Label("Summarize Note", systemImage: "sparkles")
                    }
                } preview: {
                    Markdown(notes)
                        .markdownTheme(.fancy)
                        .font(.system(.body, design: .serif))
                        .scaleEffect(0.5)
                }
        }
        .padding(32)
        .background(
            ZStack {
                if showNoteOptions {
                    AnimatedMeshGradient()
                        .mask(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 16)
                                .blur(radius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 3)
                                .blur(radius: 2)
                                .blendMode(.overlay)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 1)
                                .blur(radius: 1)
                                .blendMode(.overlay)
                        )
                }
            }
        )
        .background(Color(.systemBackground))
        .cornerRadius(showNoteOptions ? 16 : 0)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .scaleEffect(showNoteOptions ? 0.9 : 1)
    }
}

#Preview {
    GeneratedNote(
        notes: "",
        showNoteOptions: false,
        summarize: { }
    )
}
