//
//  PromptsList.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 25/2/2025.
//

import SwiftUI

struct PromptsList: View {
    @State private var viewModel: PromptsViewModel
    = Injector.instance.container.resolve(PromptsViewModel.self)!
    
    @State var show: Bool = false
    
    let onSelect: (PromptEntity) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.prompts) { prompt in
                    PromptItem(
                        prompt: prompt,
                        selectItem: onSelect,
                        isDisabled: viewModel.selectedPrompt != nil,
                        isSelected: viewModel.selectedPrompt == prompt,
                        longPress: viewModel.setHighlighted(_:),
                        deleteItem: viewModel.showDeleteAlert,
                        editItem: viewModel.showEditSheet
                    )
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 8)
        }
        .onAppear { viewModel.load() }
        .alert("Delete Prompt?", isPresented: viewModel.showDeleteAlertBinding) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) { viewModel.delete() }
        }
        .sheet(isPresented: viewModel.showEditSheetBinding) {
            SavePromptSheet(
                promptContent: viewModel.selectedPrompt!.content,
                editablePrompt: viewModel.selectedPrompt!
            )
        }
    }
}

#Preview {
    PromptsList { _ in }
}
