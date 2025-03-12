//
//  PromptViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI

@Observable
class SavePromptViewModel {
    let localPromptsService: LocalPromptsService
    
    init(localPromptsService: LocalPromptsService) {
        self.localPromptsService = localPromptsService
    }
    
    var prompt: PromptEntity? = nil
    var title: String = ""
    var subtitle: String = ""
    var content: String = ""
    
    var isFormValid: Bool {
        title.isEmpty == false
        && content.isEmpty == false
        && title.count <= 15
    }
    
    func setContent(content: String, prompt: PromptEntity?) {
        self.content = content
        
        if let prompt = prompt {
            self.prompt = prompt
            self.title = prompt.title
            self.subtitle = prompt.subtitle
        }
    }
}

// MARK: LocalPromptsService
extension SavePromptViewModel {
    func savePrompt() {
        do {
            if let prompt = prompt {
                try localPromptsService.updatePrompt(title: title, subtitle: subtitle, content: content, prompt: prompt)
            } else {
                try localPromptsService.insertPrompt(title: title, subtitle: subtitle, content: content)
            }
        } catch {
            print("Unable to save prompt: \(error.localizedDescription)")
        }
    }
}
