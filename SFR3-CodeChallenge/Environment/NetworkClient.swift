//
//  NetworkClient.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

protocol NetworkClientType {
    var urlSession: URLSessionType { get }
    func data(for request: URLRequest) async throws -> Data
    func data(from url: String) async throws -> Data
}

protocol URLSessionType {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionType {}

struct NetworkClient: NetworkClientType {
    let urlSession: URLSessionType
    
    init() {
        self.urlSession = URLSession.shared
    }
}

extension NetworkClientType {
    func data(for request: URLRequest) async throws -> Data {
        do {
            let response = try await urlSession.data(for: request, delegate: nil)
            return response.0 // Handle more response types
        } catch {
            throw error
        }
    }
    
    func data(from url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw
            NetworkClientError.url
        }
        do {
            let response = try await urlSession.data(from: url, delegate: nil)
            return response.0 // Handle more response types
        } catch {
            throw error
        }
    }
}

enum NetworkClientError: Error {
    case url
}
