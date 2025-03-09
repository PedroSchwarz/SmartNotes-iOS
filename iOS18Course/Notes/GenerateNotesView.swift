import SwiftUI

struct GenerateNotesView: View {
    @State private var viewModel: GenerateNotesViewModel = .init()
    @State private var animate: Bool = false
    @State private var hideFloatingActionButton: Bool = false
    
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
                                    .opacity(animate ? 1 : 0.4)
                                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
                                    .onAppear { animate = true }
                                
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
                        hideFloatingActionButton = newPhase.isScrolling
                    }
                    .onChange(of: viewModel.generatedNotes) { _, _ in
                        hideFloatingActionButton = true
                        scrollProxy.scrollTo("bottom", anchor: .bottom)
                    }
                    .overlay(alignment: .bottom) {
                        FloatingActionButton(
                            action: { scrollProxy.scrollTo("top", anchor: .top) },
                            image: "chevron.up",
                            verticalAlignment: .bottom,
                            horizontalAlignment: .center
                        )
                        .offset(y: viewModel.showScrollToTop ? 0 : 50)
                        .opacity(viewModel.showScrollToTop ? 1 : 0)
                        .animation(.default, value: viewModel.showScrollToTop)
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
                
                FloatingActionButton(
                    action: { },
                    image: "list.bullet.rectangle.portrait",
                    verticalAlignment: .top,
                    horizontalAlignment: .leading
                )
                .padding([.top, .leading])
                .offset(y: hideFloatingActionButton ? -100 : 0)
                .opacity(hideFloatingActionButton ? 0 : 1)
                .animation(.default, value: hideFloatingActionButton)
                .zIndex(100)
                
                FloatingActionButton(
                    type: viewModel.showSignUp ? .account : .regular,
                    action: viewModel.toggleSignUpVisibility,
                    image: "person.crop.circle",
                    secondaryImage: "xmark",
                    showSecondaryImage: viewModel.showSignUp,
                    verticalAlignment: .top,
                    horizontalAlignment: .trailing
                )
                .padding([.top, .trailing])
                .offset(y: hideFloatingActionButton ? -100 : 0)
                .opacity(hideFloatingActionButton ? 0 : 1)
                .animation(.default, value: hideFloatingActionButton)
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
        .environment(viewModel)
        .sheet(isPresented: .constant(false)) {
            PreviousResultsSheet()
        }
    }
}

#Preview {
    GenerateNotesView()
}
