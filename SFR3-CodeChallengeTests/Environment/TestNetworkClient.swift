//
//  TestNetworkClient.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation
@testable import SFR3_CodeChallenge

class TestNetworkClient: NetworkClientType {
    let urlSession: URLSessionType
    
    init(urlSession: URLSessionType) {
        self.urlSession = urlSession
    }
}
