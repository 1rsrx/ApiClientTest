//
//  QiitaApi.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class QiitaApiPostArticle {
    func execute(
        article: QiitaApiPostArticleRequestJSON,
        completion: @escaping ((Result<QiitaApiPostArticleResponseJSON, ApiError>) -> Void)
    ) {
        let request = QiitaApiRequest(httpBody: article)
        ApiClient().request(request, completion: completion)
    }
}

struct QiitaApiRequest: HttpRequestable {
    typealias Response = QiitaApiPostArticleResponseJSON
    typealias ErrorResponse = QiitaApiErrorResponse
    
    var baseURL: String {
        return AppConstant.Api.qiitaBaseURL
    }
    
    var path: String {
        return "items/"
    }
    
    var method: HttpMethod {
        return .post
    }
    
    var header: HttpHeader {
        return HttpHeader(ApiHeaderConstant.qiita)
    }
    
    var httpBody: Encodable?
}
