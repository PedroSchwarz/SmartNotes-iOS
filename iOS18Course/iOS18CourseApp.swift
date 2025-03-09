//
//  iOS18CourseApp.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import SwiftUI
import SwiftData

@main
struct iOS18CourseApp: App {
    var sharedModelContainer: ModelContainer? = nil
    
    init() {
        sharedModelContainer = AppDatabase.getInstance().sharedModelContainer
        ClientNetwork.initialize(baseUrl: "https://api.openai.com/v1/")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer!)
    }
}
