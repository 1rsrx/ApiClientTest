//
//  QiitaApiGetUserProfile.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class QiitaApiGetUserProfile {
    
    func execute() -> AnyPublisher<QiitaApiGetUserProfileResponseJSON, ApiError> {
        let request = QiitaApiGetUserProfileRequest()
        return ApiClient().request(request)
    }
}

struct QiitaApiGetUserProfileRequest: BaseApiRequest {
    typealias Response = QiitaApiGetUserProfileResponseJSON
    typealias ErrorResponse = QiitaApiErrorResponse
    
    var baseURL: String {
        return AppConstant.Api.qiitaBaseURL
    }
    
    var path: String {
        return "/authenticated_user"
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var header: [String : String] {
        return ApiHeaderConstant.qiita
    }
    
    var httpBody: Encodable? = nil
}
