//
//  PromptEntity.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 10/3/2025.
//

import Foundation
import SwiftData

@Model
final class PromptEntity {
    var title: String
    var subtitle: String
    var content: String
    var timestamp: Date
    var order: Int
    
    init(title: String, subtitle: String, content: String, timestamp: Date, order: Int) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.timestamp = timestamp
        self.order = order
    }
}
