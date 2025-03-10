//
//  NotesTopActions.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 9/3/2025.
//

import SwiftUI

struct NotesTopActions: View {
    let hideFloatingActionButton: Bool
    let showSignUp: Bool
    let toggleSavedNotes: () -> Void
    let toggleSignUpVisibility: () -> Void
    
    var body: some View {
        HStack {
            FloatingActionButton(
                action: toggleSavedNotes,
                image: "list.bullet.rectangle.portrait",
                verticalAlignment: .top,
                horizontalAlignment: .leading
            )
            .padding([.top, .leading])
            .offset(y: hideFloatingActionButton ? -100 : 0)
            .opacity(hideFloatingActionButton || showSignUp ? 0 : 1)
            .animation(.default, value: hideFloatingActionButton)
            .zIndex(100)
            
            FloatingActionButton(
                type: showSignUp ? .account : .regular,
                action: toggleSignUpVisibility,
                image: "person.crop.circle",
                secondaryImage: "xmark",
                showSecondaryImage: showSignUp,
                verticalAlignment: .top,
                horizontalAlignment: .trailing
            )
            .padding([.top, .trailing])
            .offset(y: hideFloatingActionButton ? -100 : 0)
            .opacity(hideFloatingActionButton ? 0 : 1)
            .animation(.default, value: hideFloatingActionButton)
            .zIndex(100)
        }
    }
}

#Preview {
    NotesTopActions(hideFloatingActionButton: false, showSignUp: false, toggleSavedNotes: {}, toggleSignUpVisibility: { })
}
