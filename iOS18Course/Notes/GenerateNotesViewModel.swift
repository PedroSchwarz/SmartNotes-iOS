//
//  GenerateNotesViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

@Observable
class GenerateNotesViewModel {
    var inputText: String = ""
    private(set) var isLoading: Bool = false
    private(set) var showSignUp: Bool = false
    private(set) var generatedNotes: String = ""
    private(set) var errorMessage: String = ""
    private(set) var showScrollToTop: Bool = false
    private(set) var animateInputField: Bool = false
    
    private var streamTask: Task<Void, Never>?
    
    var isGenerationDisabled: Bool {
        inputText.isEmpty
    }
    
    var hasErroMessage: Bool {
        errorMessage.isEmpty == false
    }
    
    var hasGeneratedNotes: Bool {
        generatedNotes.isEmpty == false
    }
    
    private var openAIService: OpenAIService {
        OpenAIService.live(client: ClientNetwork.instance!)
    }
    
    func resetinputText() {
        inputText = ""
    }
    
    func generateNotes() async {
        guard !inputText.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        generatedNotes = ""
        
        do {
            generatedNotes = try await openAIService.generateNotes(inputText)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func generateNotesStream() async {
        guard !inputText.isEmpty else { return }
        
        isLoading = true
        
        errorMessage = ""
        generatedNotes = ""
        
        // Cancel any existing stream task
        streamTask?.cancel()
        
        streamTask = Task {
            do {
                for try await chunk in openAIService.streamGeneratedNotes(inputText) {
                    generatedNotes += chunk
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func toggleSignUpVisibility() {
        showSignUp.toggle()
    }
    
    func setScrollToTop(value: Bool) {
        if showScrollToTop != value {
            showScrollToTop = value
        }
    }
    
    func useTemplate(for prompt: PromptTemplate) {
        inputText = prompt.content
        triggerInputFieldAnimation()
    }
    
    func triggerInputFieldAnimation() {
//        withAnimation(.spring) {
            animateInputField = true
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(.spring) {
                self.animateInputField = false
//            }
        }
    }
}
