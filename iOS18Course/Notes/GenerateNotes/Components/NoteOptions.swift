//
//  NoteOptions.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 9/3/2025.
//
import SwiftUI

struct NoteOptions: View {
    let showOptions: Bool
    let toggleOptions: () -> Void
    let saveNote: () -> Void
    let savePrompt: () -> Void
    let resetNote: () -> Void
    
    private let offset: CGFloat = -70
    
    var body: some View {
        ZStack {
            FloatingActionButton(
                backgroundColor: Color(.systemBackground),
                action: resetNote,
                image: "arrow.clockwise"
            )
            .opacity(showOptions ? 1 : 0)
            .offset(y: showOptions ? offset * 3 : 0)
            
            FloatingActionButton(
                backgroundColor: Color(.systemBackground),
                action: savePrompt,
                image: "pencil.and.outline"
            )
            .opacity(showOptions ? 1 : 0)
            .offset(y: showOptions ? offset * 2 : 0)
            
            FloatingActionButton(
                backgroundColor: Color(.systemBackground),
                action: saveNote,
                image: "document.badge.plus"
            )
            .opacity(showOptions ? 1 : 0)
            .offset(y: showOptions ? offset : 0)
            
            FloatingActionButton(
                backgroundColor: Color(showOptions ? .systemBackground : .secondarySystemBackground),
                action: toggleOptions,
                image: "ellipsis"
            )
        }
        .padding(.trailing, 16)
        .padding(.bottom, 8)
    }
}

#Preview {
    @Previewable @State var show: Bool = false
    
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        NoteOptions(
            showOptions: show,
            toggleOptions: { show.toggle() },
            saveNote: { },
            savePrompt: { },
            resetNote: { }
        )
    }
}
