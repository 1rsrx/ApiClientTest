//
//  ApiClientSampleTests.swift
//  ApiClientSampleTests
//
//  Created by Hikaru Kuroda on 2023/04/06.
//

import XCTest
@testable import ApiClientSample

protocol HttpResponseConvertible {
    var statusCode: Int { get }
    func toJSONData() -> Data
}

struct MockApiResponseJSON: Codable, HttpResponseConvertible {
    var statusCode: Int
    var message: String
    
    func toJSONData() -> Data {
        let data = try! JSONEncoder().encode(self)
        return data
    }
}

struct MockApiFailParseResponseJSON: Codable, HttpResponseConvertible {
    var statusCode: Int
    var someKey: String
    
    func toJSONData() -> Data {
        let data = try! JSONEncoder().encode(self)
        return data
    }
}

struct MockApiRequest: HttpRequestable {
    typealias Response = MockApiResponseJSON
    
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

struct MockApiRequestForEmptyResponse: HttpRequestable {
    typealias Response = EmptyResponse
    
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
    
    private func setResponse(responseDataObject: HttpResponseConvertible) {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: responseDataObject.statusCode,
                httpVersion: "HTTP/2",
                headerFields: [:]
            )!
                        
            return (response, responseDataObject.toJSONData())
        }
    }
    
    private func generateSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [StubURLProtocol.self]
        let session = URLSession(configuration: config)
        return session
    }
    
    func testRequest_ステータスコードが200台のとき成功になること() async throws {
        let responseJSON = MockApiResponseJSON(statusCode: 200, message: "message")
        setResponse(responseDataObject: responseJSON)
        
        let session = generateSession()
        
        let client = ApiClient(session: session)
        let request = MockApiRequest()
        let result = await client.request(request)
        
        switch result {
        case .success(let data):
            XCTAssertEqual(data.statusCode, responseJSON.statusCode)
        case .failure(_):
            XCTFail("Expected success but got failure")
        }
    }
    
    func testRequest_ステータスコードが200台でないとき失敗になること() async throws {
        let responseJSON = MockApiResponseJSON(statusCode: 403, message: "message")
        setResponse(responseDataObject: responseJSON)
        
        let session = generateSession()
        let client = ApiClient(session: session)
        let request = MockApiRequest()
        let result = await client.request(request)
        
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let err):
            let expectValue = ApiError.error(status: responseJSON.statusCode, data: responseJSON.toJSONData()).localizedDescription
            XCTAssertEqual(err.localizedDescription, expectValue)
        }
    }
    
    func testRequest_パース失敗時にパースエラーになること() async throws {
        let responseJSON = MockApiFailParseResponseJSON(statusCode: 200, someKey: "hoge")
        setResponse(responseDataObject: responseJSON)
        
        let session = generateSession()
        let client = ApiClient(session: session)
        let request = MockApiRequest()
        let result = await client.request(request)
        
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let err):
            let expectValue = ApiError.parse.localizedDescription
            XCTAssertEqual(err.localizedDescription, expectValue)
        }
    }
    
    func testRequest_空レスポンスでパース成功になること() async throws {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: "HTTP/2",
                headerFields: [:]
            )!
            
            let data = "".data(using: .utf8)
            return (response, data)
        }
        
        let session = generateSession()
        let client = ApiClient(session: session)
        let request = MockApiRequestForEmptyResponse()
        
        let result = await client.request(request)
        
        switch result {
        case .success(_):
            XCTAssertTrue(true)
        case .failure(_):
            XCTFail()
        }
    }
}

// URLSessionのテスト用
class StubURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

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
