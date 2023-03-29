//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Rhode, Rilla on 2023/03/23.
//

import XCTest
@testable import BoxOffice

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocolObject.self]
        let session = URLSession(configuration: configuration)
        
        sut = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_() {
        MockURLProtocolObject.requestHandler = { request in
            let data = StubBoxOffice().data
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "2.0", headerFields: nil)
            
            
            return (response!, data)
        }
    }
}
