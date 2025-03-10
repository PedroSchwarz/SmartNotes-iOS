//
//  SavedNotesViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import Foundation

@Observable
class SavedNotesViewModel {
    let localNotesService: LocalNotesService
    
    init(localNotesService: LocalNotesService) {
        self.localNotesService = localNotesService
    }
    
    private(set) var notes: [NoteEntity] = []
    private(set) var selectedNote: NoteEntity? = nil
    private(set) var indexesToDelete: IndexSet? = nil
    
    var notesListIsEmpty: Bool { notes.isEmpty }
    
    var showDeleteNoteAlert: Bool { indexesToDelete != nil }
    
    func setSelectedNote(_ value: NoteEntity?) {
        selectedNote = value
    }
    
    func setIndexesToDelete(_ value: IndexSet?) {
        indexesToDelete = value
    }
}

// MARK: LocalNotesService
extension SavedNotesViewModel {
    func loadNotes() {
        do {
            notes = try localNotesService.fetchNotes()
        } catch {
            print("Error trying to load notes: \(error)")
        }
    }
    
    func delete() {
        do {
            try localNotesService.deleteNote(at: indexesToDelete!, from: notes)
        } catch {
            print("Error trying to delete notes: \(error)")
        }
    }
    
    func reorder(from source: IndexSet, to destination: Int) {
        do {
            try localNotesService.reorderNotes(from: source, to: destination, notes: &notes)
        } catch {
            print("Error trying to reorder notes: \(error)")
        }
    }
}
