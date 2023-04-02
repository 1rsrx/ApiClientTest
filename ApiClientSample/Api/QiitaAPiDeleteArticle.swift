//
//  QiitaAPiDeleteArticle.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/02.
//

import Foundation
import Combine

class QiitaApiDeleteArticle {
    func execute() -> AnyPublisher<Result<EmptyResponse, ApiError>, Never> {
        let request = QiitaApiDeleteArticleRequest(itemID: "itemid")
        return ApiClient().request(request)
    }
}

struct QiitaApiDeleteArticleRequest: BaseApiRequest {
    typealias Response = EmptyResponse
    typealias ErrorResponse = QiitaApiErrorResponse
    
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
