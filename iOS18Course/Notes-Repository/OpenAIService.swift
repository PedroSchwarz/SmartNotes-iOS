//
//  OpenAIService.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import Foundation

struct OpenAIService {
    let generateNotes: (_ text: String) async throws -> String
    let streamGeneratedNotes: (_ text: String) -> AsyncThrowingStream<String, Error>
    
    init(
        generateNotes: @escaping (_: String) async throws -> String,
        streamGeneratedNotes: @escaping (_: String) -> AsyncThrowingStream<String, Error>
    ) {
        self.generateNotes = generateNotes
        self.streamGeneratedNotes = streamGeneratedNotes
    }
}


extension OpenAIService {
    static func live(client: ClientNetwork) -> Self {
        .init(
            generateNotes: {
                let messages = [
                    Message(
                        role: "system",
                        content: "You are a helpful assistant that generates well-structured notes from given text."
                    ),
                    Message(
                        role: "user",
                        content: "Please convert this text into well-structured notes: \($0)"
                    )
                ]
                
                let requestBody: [String: Any] = [
                    "model": "gpt-4o-mini",
                    "messages": messages.map { ["role": $0.role, "content": $0.content] },
                    "temperature": 0.7
                ]
                
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    fatalError("No API_KEY variable set for the environment")
                }
                
                do {
                    let result: ChatCompletionResponse = try await client.request(
                        for: "chat/completions",
                        with: apiKey,
                        httpMethod: "POST",
                        requestBody: requestBody
                    )
                    
                    return result.choices.first?.message.content ?? "No response generated"
                } catch {
                    throw error
                }
            },
            streamGeneratedNotes: { text in
                AsyncThrowingStream { continuation in
                    Task {
                        let messages = [
                            Message(role: "system", content: "You are a helpful assistant that generates well-structured notes from given text."),
                            Message(role: "user", content: "Please convert this text into well-structured notes: \(text)")
                        ]
                        
                        let requestBody: [String: Any] = [
                            "model": "gpt-4o-mini",
                            "messages": messages.map { ["role": $0.role, "content": $0.content] },
                            "temperature": 0.7,
                            "stream": true
                        ]
                        
                        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                            fatalError("No API_KEY variable set for the environment")
                        }
                        
                        do {
                            let stream: AsyncThrowingStream<StreamResponse, Error> = client.requestStream(
                                for: "chat/completions",
                                with: apiKey,
                                httpMethod: "POST",
                                requestBody: requestBody
                            )
                            
                            var accumulatedText = ""
                            
                            for try await chunk in stream {
                                if let content = chunk.choices.first?.delta.content {
                                    accumulatedText += content
                                    
                                    if accumulatedText.count > 20 {
                                        continuation.yield(accumulatedText)
                                        accumulatedText = ""
                                    }
                                }
                            }
                            
                            if !accumulatedText.isEmpty {
                                continuation.yield(accumulatedText)
                            }
                            
                            continuation.finish()
                        } catch {
                            continuation.finish(throwing: error)
                        }
                    }
                }
            }
        )
    }
}
