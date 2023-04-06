//
//  ApiClientSampleTests.swift
//  ApiClientSampleTests
//
//  Created by Hikaru Kuroda on 2023/04/06.
//

import XCTest
@testable import ApiClientSample

struct MockApiResponseJSON: Codable {
    var statusCode: Int
    var message: String
}

struct MockApiRequest: HttpRequestable {
    typealias Response = MockApiResponseJSON
    typealias ErrorResponse = EmptyResponse
    
    var baseURL: String {
        return "http://localhost:3000/"
    }
    
    var path: String {
        return ""
    }
    
    var method: ApiClientSample.HttpMethod {
        return .get
    }
    
    var header: ApiClientSample.HttpHeader {
        return HttpHeader([:])
    }
    
    var httpBody: Encodable?
    
}

final class ApiClientSampleTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() async throws {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "HTTP/2",
                headerFields: [:]
            )!
            
            guard let jsonURL = Bundle.main.url(forResource: "MockApiResponse", withExtension: "json") else {
                fatalError("MockApiResponse.json not found")
            }
            
            guard let jsonData = try? String(contentsOf: jsonURL) else {
                fatalError("fatal json to jsonData")
            }
            
            let data = jsonData.data(using: .utf8)
            return (response, data)
        }
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [StubURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let client = ApiClient(session: session)
        
        let request = MockApiRequest()
        let result = await client.request(request)
        
        switch result {
        case .success(let response):
            print(response.message)
        case .failure(let err):
            print(err)
        }
    }
}

typealias RequestHandler = ((URLRequest) throws -> (HTTPURLResponse, Data?))
class StubURLProtocol: URLProtocol {
    static var requestHandler: RequestHandler?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            fatalError("Handler is unavailable")
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch let e {
            client?.urlProtocol(self, didFailWithError: e)
        }
    }
    override func stopLoading() {}
}
