//
//  QiitaApiGetUserProfileResponseJSON.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation

struct QiitaApiGetUserProfileResponseJSON: Decodable {
    var id: String
    var name: String
    var description: String
}
