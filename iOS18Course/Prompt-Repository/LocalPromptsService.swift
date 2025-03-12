//
//  LocalPromptService.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftData
import SwiftUI

enum LocalPromptsError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
}

class LocalPromptsService {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Fetch all prompts sorted by `order`
    func fetchPrompts() throws -> [PromptEntity] {
        let fetchRequest = FetchDescriptor<PromptEntity>(sortBy: [SortDescriptor(\.order)])
        guard let results = try? modelContext.fetch(fetchRequest) else {
            throw LocalPromptsError.fetchFailed
        }
        return results
    }
    
    /// Create and save a new prompt
    func insertPrompt(title: String, subtitle: String, content: String) throws {
        let newPrompt = PromptEntity(
            title: title,
            subtitle: subtitle,
            content: content,
            timestamp: Date.now,
            order:  getNextOrder()
        )
        modelContext.insert(newPrompt)
        try saveChanges()
    }
    
    /// Create and save a new prompt
    func updatePrompt(title: String, subtitle: String, content: String, prompt: PromptEntity) throws {
        prompt.title = title
        prompt.subtitle = subtitle
        prompt.content = content
        try saveChanges()
    }
    
    /// Delete a prompt
    func deletePrompt(prompt: PromptEntity) throws {
        modelContext.delete(prompt)
        try saveChanges()
    }
    
    /// Get the count of prompts
    private func getPromptsCount()  -> Int {
        let fetchRequest = FetchDescriptor<PromptEntity>()
        guard let count = try? modelContext.fetch(fetchRequest).count else {
            return 0
        }
        return count
    }
    
    /// Get the next order number for a new prompt
    private func getNextOrder() -> Int { getPromptsCount() + 1 }
    
    /// Save changes to SwiftData
    private func saveChanges() throws {
        do {
            try modelContext.save()
        } catch {
            throw LocalPromptsError.saveFailed
        }
    }
}
