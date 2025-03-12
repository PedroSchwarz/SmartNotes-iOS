//
//  ContentView.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var appRouter: AppRouter = AppRouter()
    @State private var showSignUp: Bool = false
    @State private var showSavedNotes: Bool = false
    @State private var hideTopActions: Bool = false
    
    var body: some View {
        NavigationStack(path: $appRouter.path) {
            ZStack(alignment: .top) {
                Color(.systemGray6).ignoresSafeArea()
                
                GenerateNotesView { hideTopActions = $0 }
                    .blur(radius: showSignUp ? 5 : 0)
                
                if showSignUp {
                    SignUpView()
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .frame(maxHeight: .infinity)
                        .background(.black.opacity(0.3))
                        .ignoresSafeArea()
                        .zIndex(1)
                }
                
                TopActions(
                    hideActions: hideTopActions,
                    showSignUp: showSignUp,
                    toggleSavedNotes: { showSavedNotes.toggle() },
                    toggleSignUpVisibility: { showSignUp.toggle() }
                )
                .zIndex(100)
            }
            .sheet(isPresented: $showSavedNotes) {
                SavedNotesSheet()
                    .presentationDetents([.medium, .large])
            }
            .onTapGesture(perform: hideKeyboard)
        }
        .environment(appRouter)
    }
}

#Preview {
    ContentView()
}
