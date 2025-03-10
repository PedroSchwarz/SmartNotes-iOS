//
//  NoteEntity.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 9/3/2025.
//

import Foundation
import SwiftData

@Model
final class NoteEntity {
    var content: String
    var timestamp: Date
    var order: Int
    
    init(content: String, timestamp: Date, order: Int) {
        self.content = content
        self.timestamp = timestamp
        self.order = order
    }
}
