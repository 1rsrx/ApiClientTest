//
//  ApiHeaderConstant.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation

class ApiHeaderConstant {
    
    static let qiita: [String: String] = [
        "Authorization": "Bearer \(ApiKey.qiitaApiToken)",
        "Content-Type": "application/json"
    ]
}
