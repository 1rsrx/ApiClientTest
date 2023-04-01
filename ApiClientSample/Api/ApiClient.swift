//
//  ApiClient.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class ApiClient {
    
    func request<T: BaseApiRequest>(_ request: T) -> AnyPublisher<T.Response, ApiError> {
        return Future { promise in
            guard let url = URL(string: request.baseURL + request.path) else {
                promise(.failure(.url))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.header
            
            if let httpBody = request.httpBody {
                let httpBodyData = try! JSONEncoder().encode(httpBody)
                urlRequest.httpBody = httpBodyData
            }
            
            print("start \(urlRequest.url?.absoluteString ?? "")")
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, err in
                if let err = err {
                    if let _ = err as? URLError {
                        promise(.failure(.network))
                        return
                    }
                    
                    promise(.failure(.response))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      let data = data else {
                    promise(.failure(.emptyResponse))
                    return
                }
                
                let statusCode = response.statusCode
                if !(statusCode != 200 || statusCode != 201) {
                    // ステータスコードによるエラーパターン
                    promise(.failure(.http(status: statusCode, data: data)))
                    return
                }
                
                // レスポンスがエラー形式の場合
                do {
                    let object = try JSONDecoder().decode(T.ErrorResponse.self, from: data)
                    promise(.failure(.responseError(data: object)))
                    return
                } catch {}
                
                do {
                    let object = try JSONDecoder().decode(T.Response.self, from: data)
                    promise(.success(object))
                } catch {
                    promise(.failure(.parse))
                }
            }
            
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
