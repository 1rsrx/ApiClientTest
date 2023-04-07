//
//  QiitaAPiDeleteArticle.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/02.
//

import Foundation
import Combine

class QiitaApiDeleteArticle {
    func execute(itemID: String) async -> Result<EmptyResponse, ApiError> {
        let request = QiitaApiDeleteArticleRequest(itemID: itemID)
        return await ApiClient(session: URLSession.shared).request(request)
    }
}

struct QiitaApiDeleteArticleRequest: HttpRequestable {
    typealias Response = EmptyResponse
    
    var baseURL: String {
        return AppConstant.Api.qiitaBaseURL
    }
    
    var path: String {
        return "items/\(itemID)"
    }
    
    var method: HttpMethod {
        return .delete
    }
    
    var header: HttpHeader {
        return HttpHeader(ApiHeaderConstant.qiita)
    }
    
    var httpBody: Encodable?
    
    var itemID: String
}
