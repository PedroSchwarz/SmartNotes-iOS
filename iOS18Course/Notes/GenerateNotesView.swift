import SwiftUI
import SwiftData

struct GenerateNotesView: View {
    @State private var viewModel: GenerateNotesViewModel
    = Injector.instance.container.resolve(GenerateNotesViewModel.self)!
    
    var body: some View {
            GeometryReader { proxy in
                let height = proxy.size.height
                
                ZStack {
                    Color(.systemGray6).ignoresSafeArea()
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            LazyVStack {
                                GenerateNotesCard()
                                    .padding()
                                    .padding(.top, height * 0.1)
                                    .onScrollVisibilityChange({ isVisible in
                                        viewModel.setScrollToTop(value: !isVisible)
                                    })
                                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: viewModel.isLoading)
                                    .id("top")
                                
                                if viewModel.hasGeneratedNotes {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 30))
                                    
                                    GeneratedNote()
                                        .padding(.top)
                                        .id("bottom")
                                }
                            }
                            .blur(radius: viewModel.showSignUp ? 5 : 0)
                            .padding(.bottom, 32)
                        }
                        .scrollTargetLayout()
                        .onScrollPhaseChange { oldPhase, newPhase in
                            viewModel.setHideFloatingActionButton(newPhase.isScrolling)
                        }
                        .onChange(of: viewModel.generatedNotes) { _, _ in
                            viewModel.setHideFloatingActionButton(true)
                            scrollProxy.scrollTo("bottom", anchor: .bottom)
                        }
                        .overlay(alignment: .bottom) {
                            ScrollToTopButton(
                                show: viewModel.showScrollToTop,
                                scrollToTop: {
                                    scrollProxy.scrollTo("top", anchor: .top)
                                }
                            )
                        }
                        .if(viewModel.hasGeneratedNotes) {
                            $0.overlay(alignment: .bottomTrailing) {
                                NoteOptions(
                                    showOptions: viewModel.showNoteOptions,
                                    toggleOptions: viewModel.toggleNoteOptions,
                                    saveNote: { viewModel.showSaveNoteAlert = true }
                                )
                            }
                        }
                    }
                    
                    if viewModel.showSignUp {
                        SignUpView()
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .frame(maxHeight: .infinity)
                            .background(.black.opacity(0.3))
                            .ignoresSafeArea()
                            .zIndex(1)
                    }
                    
                    NotesTopActions(
                        hideFloatingActionButton: viewModel.hideFloatingActionButton,
                        showSignUp: viewModel.showSignUp,
                        toggleSavedNotes: { viewModel.showSavedNotes.toggle() },
                        toggleSignUpVisibility: viewModel.toggleSignUpVisibility
                    )
                    .zIndex(100)
                    
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
            }
            .onTapGesture(perform: hideKeyboard)
            .alert("Save note?", isPresented: $viewModel.showSaveNoteAlert) {
                Button("Cancel", role: .cancel) {}
                
                Button("Save", role: .none) {
                    viewModel.insertNote()
                    viewModel.toggleNoteOptions()
                }
            }
            .sheet(isPresented: $viewModel.showSavedNotes) {
                SavedNotesSheet()
                    .presentationDetents([.medium, .large])
            }
            .environment(viewModel)
    }
}

#Preview {
    GenerateNotesView()
}
