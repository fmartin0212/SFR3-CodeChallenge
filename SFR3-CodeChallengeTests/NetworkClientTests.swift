//
//  NetworkClientTests.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

@testable import SFR3_CodeChallenge
import XCTest

class NetworkClientTests: BaseTestCase {
    func testErrorCodeThrowsForURL() async {
        urlSession.enqueueResponseForURL(response: (Data(), .failure))
        
        do {
            _ = try await networkClient.data(from: "https://www.google.com")
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual((error as! NetworkClientError), .backend)
        }
    }
    
    func testErrorCodeThrowsForURLRequest() async {
        urlSession.enqueueResponseForRequest(response: (Data(), .failure))
        
        let request = URLRequest(url: URL(string: "https://www.bing.com")!)
        do {
            _ = try await networkClient.data(for: request)
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual((error as! NetworkClientError), .backend)
        }
    }
    
    func testBadURL() async {
        urlSession.enqueueResponseForURL(response: (Data(), .failure))
        
        do {
            _ = try await networkClient.data(from: "")
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual((error as! NetworkClientError), .url)
        }
    }
}
