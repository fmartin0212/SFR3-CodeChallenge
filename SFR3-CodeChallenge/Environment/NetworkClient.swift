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

class NetworkClient: NetworkClientType {
    let urlSession: URLSessionType
    
    init() {
        self.urlSession = URLSession.shared
    }
}

extension NetworkClientType {
    func data(for request: URLRequest) async throws -> Data {
        do {
            let response = try await urlSession.data(for: request, delegate: nil)
            guard let httpResponse = response.1 as? HTTPURLResponse else { throw NetworkClientError.unknown }
            switch httpResponse.statusCode {
            case (200...299):
                return response.0
            default:
                throw NetworkClientError.backend
            }
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
            guard let httpResponse = response.1 as? HTTPURLResponse else { throw NetworkClientError.unknown }
            switch httpResponse.statusCode {
            case (200...299):
                return response.0
            default:
                throw NetworkClientError.backend
            }
        } catch {
            throw error
        }
    }
}

enum NetworkClientError: Error {
    case url
    case backend
    case unknown
}
