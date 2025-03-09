//
//  PreviousResultsSheet.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 26/2/2025.
//

import SwiftUI

struct PreviousResultsSheet: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(1..<10) {
                    Text("lorem ipsum \($0)")
                }
            }
        }
    }
}

#Preview {
    PreviousResultsSheet()
}
