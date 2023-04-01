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
    case http(status: Int, data: Data)
    case responseError(data: Decodable)
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol BaseApiRequest {
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var header: [String: String] { get }
    var httpBody: Encodable? { get }
}
