//
//  PromptInput.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 12/3/2025.
//

import SwiftUI

struct PromptInput<Content: View>: View {
    let label: String
    let input: Binding<String>
    let autocapitalization: TextInputAutocapitalization
    let isInvalid: Bool
    let bottom: () -> Content
    
    init(
        label: String,
        input: Binding<String>,
        autocapitalization: TextInputAutocapitalization = .words,
        isInvalid: Bool = false,
        bottom: @escaping () -> Content = { EmptyView() }
    ) {
        self.label = label
        self.input = input
        self.autocapitalization = autocapitalization
        self.isInvalid = isInvalid
        self.bottom = bottom
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(label, text: input)
                .textInputAutocapitalization(autocapitalization)
                .font(.title3)
                .padding()
                .background(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(
                            isInvalid
                            ? .red
                            : .secondary
                        ),
                    alignment: .bottom
                )
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                )
            
            bottom()
        }
    }
}

#Preview {
    PromptInput(label: "Prompt Title*", input: .constant(""), isInvalid: false)
    
    PromptInput(label: "Prompt Title*", input: .constant(""), isInvalid: false) {
        Text("Bottom content")
    }
}
