//
//  NotesTopActions.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 9/3/2025.
//

import SwiftUI

struct TopActions: View {
    let hideActions: Bool
    let showSignUp: Bool
    let toggleSavedNotes: () -> Void
    let toggleSignUpVisibility: () -> Void
    
    var body: some View {
        HStack {
            FloatingActionButton(
                action: toggleSavedNotes,
                image: "list.bullet.rectangle.portrait"
            )
            .opacity(hideActions || showSignUp ? 0 : 1)
            .animation(.default, value: hideActions || showSignUp)
            
            Spacer()
            
//            FloatingActionButton(
//                type: showSignUp ? .account : .regular,
//                action: toggleSignUpVisibility,
//                image: "person.crop.circle",
//                secondaryImage: "xmark",
//                showSecondaryImage: showSignUp
//            )
//            .opacity(hideActions ? 0 : 1)
//            .animation(.default, value: hideActions)
        }
        .offset(y: hideActions ? -100 : 0)
        .padding([.top, .horizontal])
    }
}

#Preview {
    TopActions(hideActions: false, showSignUp: false, toggleSavedNotes: {}, toggleSignUpVisibility: { })
}
