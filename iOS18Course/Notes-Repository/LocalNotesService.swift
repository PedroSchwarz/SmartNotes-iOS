//
//  LocalNotesService.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftData
import SwiftUI

enum LocalNotesError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
}

class LocalNotesService {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Fetch all notes sorted by `order`
    func fetchNotes() throws -> [NoteEntity] {
        let fetchRequest = FetchDescriptor<NoteEntity>(sortBy: [SortDescriptor(\.order)])
        guard let results = try? modelContext.fetch(fetchRequest) else {
            throw LocalNotesError.fetchFailed
        }
        return results
    }
    
    /// Create and save a new note
    func insertNote(content: String)throws {
        let newNote = NoteEntity(content: content, timestamp: Date.now, order:  getNextOrder())
        modelContext.insert(newNote)
        try saveChanges()
    }
    
    /// Delete a note
    func deleteNote(at offsets: IndexSet, from notes: [NoteEntity])throws {
        for index in offsets {
            modelContext.delete(notes[index])
        }
        try saveChanges()
    }
    
    /// Reorder notes and update `order` property
    func reorderNotes(from source: IndexSet, to destination: Int, notes: inout [NoteEntity]) throws{
        notes.move(fromOffsets: source, toOffset: destination)
        
        // Assign new sequential order
        for (index, note) in notes.enumerated() {
            note.order = index
        }
        
        try saveChanges()
    }
    
    /// Get the count of notes
    private func getNotesCount()  -> Int {
        let fetchRequest = FetchDescriptor<NoteEntity>()
        guard let count = try? modelContext.fetch(fetchRequest).count else {
            return 0
        }
        return count
    }
    
    /// Get the next order number for a new note
    private func getNextOrder() -> Int { getNotesCount() + 1 }
    
    /// Save changes to SwiftData
    private func saveChanges() throws {
        do {
            try modelContext.save()
        } catch {
            throw LocalNotesError.saveFailed
        }
    }
}
