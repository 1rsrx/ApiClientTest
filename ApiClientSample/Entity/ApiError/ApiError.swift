//
//  ApiError.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/08.
//

import Foundation

enum ApiError: Error {
    case url
    case network
    case response
    case emptyResponse
    case parse
    case error(status: Int, data: Data)
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .url:
            return "URLが無効"
        case .network:
            return "ネットワーク未接続"
        case .response:
            return "レスポンス取得失敗"
        case .emptyResponse:
            return "レスポンスが空"
        case .parse:
            return "パースエラー"
        case .error(status: let status, data: let data):
            return "エラー statusCode: \(status), data: \(data)"
        }
    }
}
