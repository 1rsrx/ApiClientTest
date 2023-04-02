//
//  BaseApiRequest.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation

enum ApiError: Error {
    case url
    case network
    case response
    case emptyResponse
    case parse
    case errorResponse(status: Int, data: Decodable)
    case error(status: Int, data: Data)
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol HttpRequestable {
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var header: HttpHeader { get }
    var httpBody: Encodable? { get }
}

class HttpHeader {
    private var header: [String: String]
    
    init(_ header: [String: String]) {
        self.header = header
    }
    
    func addValues(_ values: [String: String]) -> HttpHeader {
        var header = self.header
        
        values.forEach { (key, value) in
            header[key] = value
        }
        
        return HttpHeader(header)
    }
    
    func values() -> [String:String] {
        return self.header
    }
}
