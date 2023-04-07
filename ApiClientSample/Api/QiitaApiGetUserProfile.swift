//
//  QiitaApiGetUserProfile.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class QiitaApiGetUserProfile {
    
    func execute() -> AnyPublisher<Result<QiitaApiGetUserProfileResponseJSON, ApiError>, Never> {
        let request = QiitaApiGetUserProfileRequest()
        return ApiClient().request(request)
    }
}

struct QiitaApiGetUserProfileRequest: HttpRequestable {
    typealias Response = QiitaApiGetUserProfileResponseJSON
    
    var baseURL: String {
        return AppConstant.Api.qiitaBaseURL
    }
    
    var path: String {
        return "/authenticated_user"
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var header: HttpHeader {
        return HttpHeader(ApiHeaderConstant.qiita)
    }
    
    var httpBody: Encodable? = nil
}
