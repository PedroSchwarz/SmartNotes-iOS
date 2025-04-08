//
//  SpeechToTextButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 8/4/2025.
//

import SwiftUI

struct SpeechToTextButton: View {
    @State private var isRecording: Bool = false
    @State private var isPressing: Bool = false
    var onToggle: (_ isRecording: Bool) -> Void
    
    var body: some View {
        Circle()
            .fill(.clear)
            .frame(width: 50, height: 50)
            .overlay {
                Image(systemName: isRecording ? "microphone.fill" : "microphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.wholeSymbol), options: .repeat(.continuous)))
                    .overlay {
                        if isRecording {
                            AnimatedMeshGradient()
                                .mask(
                                    Image(systemName: "microphone.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                )
                        }
                    }
            }
            .overlay {
                if isPressing || isRecording {
                    AnimatedMeshGradient()
                        .mask(Circle().stroke(lineWidth: 10).blur(radius: 5))
                        .clipShape(Circle())
                        .transition(.opacity.animation(.easeInOut(duration: 1)))
                } else {
                    Circle()
                        .stroke(lineWidth: 1)
                        .fill(.primary.opacity(0.2))
                }
            }
            .onLongPressGesture(minimumDuration: isRecording ? 0.3 : 1) {
                isRecording.toggle()
                withAnimation(.spring(response: 1, dampingFraction: 0.2, blendDuration: 100.0)) {
                    self.isPressing = false
                }
                onToggle(isRecording)
            } onPressingChanged: { isPressing in
                withAnimation(.spring(response: 1, dampingFraction: 0.2, blendDuration: 100.0)) {
                    self.isPressing = isPressing
                }
            }
            .scaleEffect(isPressing ? 1.1 : 1)
    }
}

#Preview {
    SpeechToTextButton { _ in }
}
