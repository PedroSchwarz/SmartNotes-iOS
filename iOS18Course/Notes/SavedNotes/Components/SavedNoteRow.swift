//
//  SavedNotesList.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI
import MarkdownUI

struct SavedNoteRow: View {
    let note: NoteEntity
    let selectNote: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.spring()) { selectNote() }
        } label: {
            Markdown(note.content)
                .markdownTheme(.fancy)
                .textSelection(.enabled)
                .multilineTextAlignment(.leading)
                .font(.system(.body, design: .serif))
                .frame(maxHeight: 60, alignment: .topLeading)
                .clipped()
                .padding(.trailing, 32)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.secondary)
                }
                .padding(.vertical)
        }
        
    }
}

//#Preview {
//    SavedNoteRow(note: [], selectNote: { _ in })
//}
