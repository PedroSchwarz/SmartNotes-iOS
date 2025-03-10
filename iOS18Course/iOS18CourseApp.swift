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
    init() {
        Injector.instance.inject()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
