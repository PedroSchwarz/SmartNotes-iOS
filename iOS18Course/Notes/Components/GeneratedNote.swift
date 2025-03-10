//
//  GeneratedNoteCard.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI
import MarkdownUI

struct GeneratedNote: View {
    @Environment(GenerateNotesViewModel.self) private var viewModel: GenerateNotesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Generated Notes")
                .font(.headline)
                .padding(.top)
            
            Markdown(viewModel.generatedNotes)
                .markdownTheme(.fancy)
                .textSelection(.enabled)
                .font(.system(.body, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(32)
        .if(viewModel.showNoteOptions) {
            $0.background(
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
            )
        }
        .background(Color(.systemBackground))
        .cornerRadius(viewModel.showNoteOptions ? 16 : 0)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .scaleEffect(viewModel.showNoteOptions ? 0.9 : 1)
    }
}

#Preview {
    @Previewable @State var viewModel: GenerateNotesViewModel
    = Injector.instance.container.resolve(GenerateNotesViewModel.self)!
    
    GeneratedNote()
        .environment(viewModel)
}
