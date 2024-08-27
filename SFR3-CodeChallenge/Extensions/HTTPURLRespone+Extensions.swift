//
//  HTTPURLRespone+Extensions.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

extension URLResponse {
    static var success: URLResponse {
        let statusCode = 200
        let url = URL(string: "www.google.com")!
        
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "", headerFields: [:])! as URLResponse
    }
    
    static var failure: URLResponse {
        let statusCode = 401
        let url = URL(string: "www.google.com")!
        
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "", headerFields: [:])! as URLResponse
    }
}
