//
//  Injector.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import Foundation
import Swinject
import SwiftData

struct Injector {
    static var instance: Injector = .init()
    
    let container: Container = .init()
    
    @MainActor
    func inject() {
        let appDatabase = AppDatabase.instance
        
        container.register(AppDatabase.self, factory: { _ in appDatabase })
            .inObjectScope(.container)
        
        container.register(ModelContext.self, factory: { r in appDatabase.sharedModelContainer!.mainContext })
            .inObjectScope(.container)
        
        container.register(LocalNotesService.self, factory: { r in LocalNotesService(modelContext: r.resolve(ModelContext.self)!) })
            .inObjectScope(.container)
        
        ClientNetwork.initialize(baseUrl: "https://api.openai.com/v1/")
        
        container.register(ClientNetwork.self, factory: { _ in ClientNetwork.instance })
            .inObjectScope(.container)
        
        container.register(OpenAIService.self, factory: { r in OpenAIService.live(client: r.resolve(ClientNetwork.self)!) })
            .inObjectScope(.container)
        
        container.register(GenerateNotesViewModel.self, factory: { r in
                .init(
                    openAIService: r.resolve(OpenAIService.self)!,
                    localNotesService: r.resolve(LocalNotesService.self)!
                )
        })
        
        container.register(SavedNotesViewModel.self, factory: { r in
                .init(localNotesService: r.resolve(LocalNotesService.self)!)
        })
    }
}
