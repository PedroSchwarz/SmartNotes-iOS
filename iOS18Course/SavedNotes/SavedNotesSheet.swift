//
//  PreviousResultsSheet.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 26/2/2025.
//

import SwiftUI
import SwiftData
import MarkdownUI

struct SavedNotesSheet: View {
    @State private var viewModel: SavedNotesViewModel
    = Injector.instance.container.resolve(SavedNotesViewModel.self)!
    
    var body: some View {
        Group {
            if let note = viewModel.selectedNote {
                ScrollView {
                    Markdown(note.content)
                        .markdownTheme(.fancy)
                        .textSelection(.enabled)
                        .multilineTextAlignment(.leading)
                        .font(.system(.body, design: .serif))
                        .padding(.vertical, 32)
                        .padding(.horizontal)
                }
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        withAnimation(.spring()) { viewModel.setSelectedNote(nil) }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.primary)
                            .padding(12)
                            .background(Circle().fill(Color(.systemBackground)))
                            .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
                            .padding()
                    }
                })
                .transition(
                    .move(edge: .top).animation(.easeIn(duration: 1.2))
                    .combined(with: .opacity.animation(.easeIn(duration: 0.8)))
                )
            } else {
                List {
                    if viewModel.notesListIsEmpty {
                        VStack(spacing: 32) {
                            Text("No notes saved yet.")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Start by generating a note using AI or save your own. Your notes will appear here for easy access whenever you need them.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                    }
                    
                    ForEach(viewModel.notes) { note in
                        Button {
                            withAnimation(.spring()) { viewModel.setSelectedNote(note) }
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
                    .onDelete { indexes in viewModel.setIndexesToDelete(indexes) }
                    .onMove(perform: viewModel.reorder)
                    .animation(.easeOut, value: viewModel.notes)
                }
                .padding(.top, 32)
                .listStyle(.plain)
                .transition(
                    .move(edge: .bottom).animation(.easeIn(duration: 1.2))
                    .combined(with: .opacity.animation(.easeIn(duration: 0.8)))
                )
                .alert("Delete note?", isPresented: .init(get: {
                    viewModel.showDeleteNoteAlert
                }, set: { _ in
                    viewModel.setIndexesToDelete(nil)
                })) {
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
        .onAppear {
            viewModel.loadNotes()
        }
    }
}

#Preview {
    SavedNotesSheet()
}
