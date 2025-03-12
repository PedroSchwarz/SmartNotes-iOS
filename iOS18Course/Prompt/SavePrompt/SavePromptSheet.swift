//
//  SavePromptSheet.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import SwiftUI

struct SavePromptSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SavePromptViewModel
    = Injector.instance.container.resolve(SavePromptViewModel.self)!
    
    let promptContent: String
    let editablePrompt: PromptEntity?
    
    init(promptContent: String, editablePrompt: PromptEntity? = nil) {
        self.promptContent = promptContent
        self.editablePrompt = editablePrompt
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Save Prompt")
                        .font(.title)
                    
                    PromptInput(
                        label: "Prompt title*",
                        input: $viewModel.title,
                        isInvalid: viewModel.title.count > 15
                    ) {
                        Text("\(viewModel.title.count)/15 characters")
                            .font(.callout)
                            .foregroundStyle(
                                viewModel.title.count > 15
                                ? .red
                                : .secondary
                            )
                    }
                    
                    PromptInput(
                        label: "Prompt subtitle",
                        input: $viewModel.subtitle,
                        autocapitalization: .sentences
                    )
                    
                    TextEditor(text: $viewModel.content)
                        .frame(height: 200)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.primary, lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    Button {
                        viewModel.savePrompt()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke()
                                    .fill(.secondary)
                            )
                    }
                    .foregroundStyle(.primary)
                    .opacity(viewModel.isFormValid == false ? 0.5 : 1)
                    .disabled(viewModel.isFormValid == false)
                    .animation(.easeInOut, value: viewModel.isFormValid)
                }
                .padding()
                .padding(.top, 32)
                .frame(minHeight: size.height)
            }
        }
        .onTapGesture(perform: hideKeyboard)
        .onAppear { viewModel.setContent(content: promptContent, prompt: editablePrompt) }
    }
}

#Preview {
    SavePromptSheet(promptContent: "Content")
}
