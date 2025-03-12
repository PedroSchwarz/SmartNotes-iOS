//
//  PreviousResultsSheet.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 26/2/2025.
//

import SwiftUI
import MarkdownUI

struct SavedNotesSheet: View {
    @State private var viewModel: SavedNotesViewModel
    = Injector.instance.container.resolve(SavedNotesViewModel.self)!
    
    var body: some View {
        Group {
            if let note = viewModel.selectedNote {
                FullNoteContent(
                    content: note.content,
                    closeNote: { viewModel.setSelectedNote(nil) }
                )
                .transition(
                    .move(edge: .top).animation(.easeIn(duration: 1.2))
                    .combined(with: .opacity.animation(.easeIn(duration: 0.8)))
                )
            } else {
                List {
                    if viewModel.notesListIsEmpty {
                        EmptyNotesContent().listRowSeparator(.hidden)
                    }
                    
                    ForEach(viewModel.notes) { note in
                        SavedNoteRow(
                            note: note,
                            selectNote: { viewModel.setSelectedNote(note) }
                        )
                    }
                    .onDelete(perform: viewModel.setIndexesToDelete(_:))
                    .onMove(perform: viewModel.reorder)
                    .animation(.easeOut, value: viewModel.notes)
                }
                .padding(.top, 32)
                .listStyle(.plain)
                .transition(
                    .move(edge: .bottom).animation(.easeIn(duration: 1.2))
                    .combined(with: .opacity.animation(.easeIn(duration: 0.8)))
                )
                .alert("Delete note?", isPresented: viewModel.showDeleteAlert) {
                        Button("Cancel", role: .cancel) {}
                        
                        Button("Delete", role: .destructive) {
                            withAnimation(.spring()) {
                                viewModel.delete()
                            }
                        }
                    }
            }
        }
        .animation(.spring(), value: viewModel.selectedNote)
        .onAppear { viewModel.load() }
    }
}

#Preview {
    SavedNotesSheet()
}
