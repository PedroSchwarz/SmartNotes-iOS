//
//  GenerateNotesCard.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct GenerateNotesCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool
    
    let input: Binding<String>
    let isLoading: Bool
    let isButtonDisabled: Bool
    let isRecordingEnabled: Bool
    let selectPrompt: (PromptEntity) -> Void
    let resetInput: () -> Void
    let animateInput: Bool
    let errorMessage: String
    let generateNotes: () async -> Void
    let onRecordingChanged: (_ isRecording: Bool) -> Void
    
    var hasErrorMessage: Bool {
        errorMessage.isEmpty == false
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                if !isLoading {
                    Text("Generate Notes")
                        .customAttribute(EmphasisAttribute())
                        .transition(TextTransition())
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("Transform your thoughts into well-structured notes using artificial intelligence.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 32)
            
            PromptsList(onSelect: selectPrompt)
            
            VStack(spacing: 20) {
                TextEditor(text: input)
                    .frame(height: 200)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.primary.opacity(isFocused ? 0.6 : 0.2), lineWidth: 1)
                            .animation(.linear, value: isFocused)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
                    )
                    .focused($isFocused)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button(action: resetInput) {
                                Text("Clear text")
                            }
                        }
                    }
                    .scaleEffect(animateInput ? 1.05 : 1)
                    .overlay {
                        if animateInput {
                            AnimatedMeshGradient()
                                .blendMode(colorScheme == .dark ? .darken : .screen)
                        }
                    }
                    .animation(.easeOut, value: animateInput)
                
                HStack {
                    PrimaryButton(
                        label: isLoading ? "Generating..." : "Generate Notes",
                        image: "sparkles",
                        isLoading: isLoading,
                        isDisabled: isButtonDisabled
                    ) {
                        Task {
                            await generateNotes()
                            hideKeyboard()
                        }
                    }
                    
                    if (isRecordingEnabled) {
                        SpeechToTextButton(onToggle: onRecordingChanged)
                    }
                }
                
                if hasErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 32)
        }
        .padding(.vertical, 32)
        .background(Color(.systemBackground))
        .cornerRadius(44)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    GenerateNotesCard(
        input: .constant(""),
        isLoading: false,
        isButtonDisabled: false,
        isRecordingEnabled: true,
        selectPrompt: { _ in },
        resetInput: { },
        animateInput: false,
        errorMessage: "",
        generateNotes: { },
        onRecordingChanged: { _ in }
    )
}
