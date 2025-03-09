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
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    GeneratedNote()
}
