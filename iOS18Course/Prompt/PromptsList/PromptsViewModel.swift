//
//  PromptViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI

@Observable
class PromptsViewModel {
    let localPromptsService: LocalPromptsService
    
    init(localPromptsService: LocalPromptsService) {
        self.localPromptsService = localPromptsService
    }
    
    var prompts: [PromptEntity] = []
    private(set) var selectedPrompt: PromptEntity? = nil
    private var deleteAlert: Bool = false
    private var editSheet: Bool = false
    
    var showDeleteAlertBinding: Binding<Bool> {
        .init { self.deleteAlert }
        set: { value in self.deleteAlert = value }
    }
    
    var showEditSheetBinding: Binding<Bool> {
        .init { self.editSheet }
        set: { value in self.editSheet = value }
    }
    
    func showDeleteAlert() { deleteAlert = true }
    
    func showEditSheet() { editSheet = true }
    
    func setHighlighted(_ prompt: PromptEntity?) {
        selectedPrompt = prompt
    }
}

// MARK: LocalPromptsService
extension PromptsViewModel {
    func load() {
        do {
            self.prompts = try localPromptsService.fetchPrompts()
        } catch {
            print("Unable to load prompts: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        do {
            try localPromptsService.deletePrompt(prompt: selectedPrompt!)
            prompts = prompts.filter({ prompt in prompt.id != selectedPrompt!.id })
            selectedPrompt = nil
        } catch {
            print("Error trying to delete prompt: \(error)")
        }
    }
}
