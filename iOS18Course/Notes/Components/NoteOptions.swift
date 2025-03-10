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
    
    var body: some View {
        ZStack {
            FloatingActionButton(
                backgroundColor: Color(.systemBackground),
                action: saveNote,
                image: "plus",
                verticalAlignment: .bottom,
                horizontalAlignment: .trailing
            )
            .opacity(showOptions ? 1 : 0)
            .offset(y: showOptions ? -70 : 0)
            
            FloatingActionButton(
                backgroundColor: Color(showOptions ? .systemBackground : .secondarySystemBackground),
                action: toggleOptions,
                image: "ellipsis",
                secondaryImage: "xmark",
                showSecondaryImage: showOptions,
                verticalAlignment: .bottom,
                horizontalAlignment: .trailing
            )
            
        }
        .padding(16)
    }
}

#Preview {
    @Previewable @State var show: Bool = false
    
    NoteOptions(showOptions: show, toggleOptions: { show.toggle() }, saveNote: { })
}
