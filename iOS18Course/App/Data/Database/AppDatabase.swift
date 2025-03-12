//
//  AppDatabase.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import Foundation
import SwiftData

struct AppDatabase {
    static var instance: AppDatabase = .init()
    
    var sharedModelContainer: ModelContainer? = nil
    
    init() {
        sharedModelContainer = {
            let schema = Schema([
                NoteEntity.self,
                PromptEntity.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    }
}
