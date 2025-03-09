//
//  ContentView.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    @State private var appRouter: AppRouter = AppRouter()

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            Group {
                GenerateNotesView()
            }
            .environment(appRouter)
            .navigationDestination(for: PreviousResultsRoutes.self) { route in
                switch route {
                case .previousResultNote(let notes):
                    Text("here are your notes: \(notes)")
                }
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
