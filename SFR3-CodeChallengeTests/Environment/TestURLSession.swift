//
//  TestURLSession.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation
@testable import SFR3_CodeChallenge

class TestURLSession: URLSessionType {
    var requestResponses: [(Data, URLResponse)] = []
    var urlResponses: [(Data, URLResponse)] = []
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        requestResponses.popLast()!
    }
    
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        urlResponses.popLast()!
    }
    
    func enqueueResponseForRequest(response: (Data, URLResponse)) {
        requestResponses.append(response)
    }
    
    func enqueueResponseForURL(response: (Data, URLResponse)) {
        urlResponses.append(response)
    }
}
