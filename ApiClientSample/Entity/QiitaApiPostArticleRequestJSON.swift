//
//  QiitaPostArticleRequestJSON.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation

struct QiitaApiPostArticleRequestJSON: Encodable {
    var body: String
    var `private`: Bool
    var tags: [Tag]
    var title: String
    var tweet: Bool

    struct Tag: Encodable {
        var name: String
        var versions: [String]
    }
}

extension QiitaApiPostArticleRequestJSON {
    func httpBody() -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data
    }
}
