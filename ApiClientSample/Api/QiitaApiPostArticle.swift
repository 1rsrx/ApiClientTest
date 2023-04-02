//
//  QiitaApi.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class QiitaApiPostArticle {
    func execute() -> AnyPublisher<Result<QiitaApiPostArticleResponseJSON, ApiError>, Never> {
        let article = QiitaApiPostArticleRequestJSON(
            body: "本文",
            private: true,
            tags: [
                .init(name: "swift", versions: ["0.0.1"])
            ],
            title: "title",
            tweet: false
        )
        let request = QiitaApiRequest(httpBody: article)
        return ApiClient().request(request)
    }
}

struct QiitaApiRequest: BaseApiRequest {
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
