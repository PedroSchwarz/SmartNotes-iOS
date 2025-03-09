//
//  GenerateNotesCard.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct GenerateNotesCard: View {
    @Environment(GenerateNotesViewModel.self) private var viewModel: GenerateNotesViewModel
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                if !viewModel.isLoading {
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
            
            PromptsList(onSelect: viewModel.useTemplate(for:))
            
            VStack(spacing: 20) {
                TextEditor(text: $viewModel.inputText)
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
                            Button(action: {
                                viewModel.resetinputText()
                            }) {
                                Text("Clear text")
                            }
                        }
                    }
                    .scaleEffect(viewModel.animateInputField ? 1.05 : 1)
                    .overlay {
                        if viewModel.animateInputField {
                            AnimatedMeshGradient()
                                .blendMode(colorScheme == .dark ? .darken : .screen)
                        }
                    }
                    .animation(.easeOut, value: viewModel.animateInputField)
                
                PrimaryButton(
                    isLoading: viewModel.isLoading,
                    isDisabled: viewModel.isGenerationDisabled
                ) {
                    Task {
                        await viewModel.generateNotesStream()
                        hideKeyboard()
                    }
                }
                
                if viewModel.hasErroMessage {
                    Text(viewModel.errorMessage)
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
    @Previewable @State var viewModel: GenerateNotesViewModel = .init()
    
    GenerateNotesCard()
        .environment(viewModel)
}
