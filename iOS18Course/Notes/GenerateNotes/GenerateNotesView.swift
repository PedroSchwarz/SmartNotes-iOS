import SwiftUI
import SwiftData

struct GenerateNotesView: View {
    @State private var viewModel: GenerateNotesViewModel
    = Injector.instance.container.resolve(GenerateNotesViewModel.self)!
    
    let hideTopActions: (Bool) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack {
                        GenerateNotesCard(
                            input: $viewModel.inputText,
                            isLoading: viewModel.isLoading,
                            isButtonDisabled: viewModel.isGenerationDisabled,
                            isRecordingEnabled: viewModel.isRecordingEnabled,
                            selectPrompt: viewModel.usePrompt(for:),
                            resetInput: viewModel.resetinputText,
                            animateInput: viewModel.animateInputField,
                            errorMessage: viewModel.errorMessage,
                            generateNotes: viewModel.generateNotesStream,
                            onRecordingChanged: viewModel.handleRecording(_:)
                        )
                        .padding()
                        .padding(.top, height * 0.1)
                        .onScrollVisibilityChange({ isVisible in viewModel.setScrollToTop(value: !isVisible) })
                        .animation(.easeInOut(duration: 0.5).delay(0.5), value: viewModel.isLoading)
                        .id("top")
                        
                        if viewModel.hasGeneratedNotes {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 30))
                                .foregroundStyle(.secondary)
                            
                            GeneratedNote(
                                notes: viewModel.generatedNotes,
                                showNoteOptions: viewModel.showNoteOptions,
                                summarize: {
                                    scrollProxy.scrollTo("top")
                                    
                                    Task {
                                        await viewModel.summarizeNote()
                                        
                                        DispatchQueue.main.async {
                                            scrollProxy.scrollTo("bottom", anchor: .bottom)
                                        }
                                    }
                                }
                            )
                            .padding(.top)
                            .padding(.bottom, 32)
                            .id("bottom")
                        }
                    }
                    .scrollTargetLayout()
                }
                .onScrollPhaseChange { _, phase in hideTopActions(phase.isScrolling) }
                .onChange(of: viewModel.generatedNotes) { _, _ in
                    scrollProxy.scrollTo("bottom", anchor: .bottom)
                }
                .overlay(alignment: .bottom) {
                    ScrollToTopButton(
                        show: viewModel.showScrollToTop,
                        scrollToTop: {
                            viewModel.toggleNoteOptions()
                            scrollProxy.scrollTo("top", anchor: .top)
                        }
                    )
                }
                .if(viewModel.hasGeneratedNotes) {
                    $0.overlay(alignment: .bottomTrailing) {
                        NoteOptions(
                            showOptions: viewModel.showNoteOptions,
                            toggleOptions: {
                                withAnimation(.spring) {
                                    viewModel.toggleNoteOptions()
                                }
                            },
                            saveNote: viewModel.showNoteAlert,
                            savePrompt: viewModel.showPromptSheet,
                            resetNote: {
                                withAnimation(.spring) {
                                    viewModel.resetState()
                                }
                            }
                        )
                    }
                }
            }
            
            if viewModel.isLoading {
                AnimatedMeshGradient()
                    .mask {
                        RoundedRectangle(cornerRadius: 44)
                            .stroke(lineWidth: 44)
                            .blur(radius: 22)
                    }
                    .ignoresSafeArea()
            }
        }
        .sensoryFeedback(.selection, trigger: viewModel.generatedNotes)
        .alert("Save note?", isPresented: viewModel.showSaveNoteAlertBinding) {
            Button("Cancel", role: .cancel) {}
            
            Button("Save", role: .none) {
                viewModel.insertNote()
                withAnimation(.spring) {
                    viewModel.toggleNoteOptions()
                }
            }
        }
        .task { await viewModel.checkIfCanRecord() }
        .sheet(isPresented: viewModel.showPromptSheetBinding) { SavePromptSheet(promptContent: viewModel.inputText) }
        .environment(viewModel)
    }
}

#Preview {
    GenerateNotesView { _ in }
}
