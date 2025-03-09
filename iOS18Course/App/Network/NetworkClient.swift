//
//  NetworkClient.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import Foundation

struct ClientNetwork {
    let baseUrl: String
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    
    static var instance: ClientNetwork?
    
    static func initialize(baseUrl: String) {
        if instance == nil {
            instance = ClientNetwork(
                baseUrl: baseUrl,
                urlSession: URLSession.shared,
                jsonDecoder: JSONDecoder()
            )
        }
    }
    
    func request<R: Decodable>(
        for endpoint: String,
        with token: String,
        httpMethod: String = "GET",
        requestBody: [String: Any]
    ) async throws -> R {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if httpMethod == "POST" {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try jsonDecoder.decode(R.self, from: data)
        } catch {
            throw error
        }
    }
    
    func requestStream<R: Decodable>(
        for endpoint: String,
        with token: String,
        httpMethod: String = "GET",
        requestBody: [String: Any]
    ) -> AsyncThrowingStream<R, Error> {
        AsyncThrowingStream { continuation in
            Task {
                guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
                    continuation.finish(throwing: URLError(.badURL))
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = httpMethod
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if httpMethod == "POST" {
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                }
                
                do {
                    let (result, response) = try await urlSession.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.finish(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        print(httpResponse.statusCode)
                        continuation.finish(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    for try await line in result.lines {
                        if line.hasPrefix("data: "), let data = line.dropFirst(6).data(using: .utf8) {
                            if line.contains("[DONE]") {
                                continuation.finish()
                                return
                            }
                            
                            do {
                                let streamResponse = try JSONDecoder().decode(R.self, from: data)
                                continuation.yield(streamResponse)
                            } catch {
                                print("Decoding error: \(error)")
                            }
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
