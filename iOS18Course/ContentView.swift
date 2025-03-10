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

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            Group {
                GenerateNotesView()
            }
            .environment(appRouter)
        }
    }
}

#Preview {
    ContentView()
}
