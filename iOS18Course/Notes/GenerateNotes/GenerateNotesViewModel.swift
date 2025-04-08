//
//  GenerateNotesViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

@Observable
class GenerateNotesViewModel {
    let openAIService: OpenAIService
    let localNotesService: LocalNotesService
    let speechRecognizer: SpeechRecognizer
    
    init(openAIService: OpenAIService, localNotesService: LocalNotesService, speechRecognizer: SpeechRecognizer) {
        self.openAIService = openAIService
        self.localNotesService = localNotesService
        self.speechRecognizer = speechRecognizer
    }
    
    var inputText: String = ""
    private(set) var isLoading: Bool = false
    private(set) var generatedNotes: String = ""
    private(set) var errorMessage: String = ""
    private(set) var showScrollToTop: Bool = false
    private(set) var animateInputField: Bool = false
    private(set) var showNoteOptions: Bool = false
    private(set) var isRecordingEnabled: Bool = false
    private var saveNoteAlert: Bool = false
    private var savePromptSheet: Bool = false
    
    var showSaveNoteAlertBinding: Binding<Bool> {
        .init { self.saveNoteAlert }
        set: { value in self.saveNoteAlert = value }
    }
    
    var showPromptSheetBinding: Binding<Bool> {
        .init { self.savePromptSheet }
        set: { value in self.savePromptSheet = value }
    }
    
    private var streamTask: Task<Void, Never>?
    
    var isGenerationDisabled: Bool { inputText.isEmpty }
    
    var hasGeneratedNotes: Bool { generatedNotes.isEmpty == false }
    
    func showNoteAlert() { saveNoteAlert = true }
    
    func showPromptSheet() { savePromptSheet = true }
    
    func resetinputText() { inputText = "" }
    
    func setScrollToTop(value: Bool) {
        if showScrollToTop != value {
            showScrollToTop = value
        }
    }
    
    func usePrompt(for prompt: PromptEntity) {
        inputText = prompt.content
        triggerInputFieldAnimation()
    }
    
    func triggerInputFieldAnimation() {
        animateInputField = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateInputField = false
        }
    }
    
    func toggleNoteOptions() {
        showNoteOptions.toggle()
    }
    
    func resetState() {
        inputText = ""
        generatedNotes = ""
        errorMessage = ""
        showScrollToTop = false
        showNoteOptions = false
    }
}

// MARK: OpenAIService
extension GenerateNotesViewModel {
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
    
    @MainActor
    func generateNotesStream() async {
        guard !inputText.isEmpty else { return }
        
        isLoading = true
        
        errorMessage = ""
        generatedNotes = ""
        
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
    
    @MainActor
    func summarizeNote() async {
        guard !generatedNotes.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        generatedNotes = ""
        
        do {
            generatedNotes = try await openAIService.summarizeNotes(inputText)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: LocalNotesService
extension GenerateNotesViewModel {
    func insertNote() {
        do {
            try localNotesService.insertNote(content: generatedNotes)
        } catch {
            print("Error inserting note: \(error.localizedDescription)")
        }
    }
}

// MARK: SpeechRecognizer
extension GenerateNotesViewModel {
    @MainActor
    func checkIfCanRecord() async {
        isRecordingEnabled = await speechRecognizer.canRecordAudio()
    }
    
    @MainActor
    func handleRecording(_ isRecording: Bool) {
        if isRecording {
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
        } else {
            speechRecognizer.stopTranscribing()
            inputText = speechRecognizer.transcript
        }
    }
}
