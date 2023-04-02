//
//  ApiClient.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import Foundation
import Combine

class ApiClient {
    
    func request<T: BaseApiRequest>(
        _ request: T,
        completion: @escaping ((Result<T.Response, ApiError>) -> Void)
    ) {
        guard let url = URL(string: request.baseURL + request.path) else {
            completion(Result<T.Response, ApiError>.failure(.url))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.header.values()
        
        if let httpBody = request.httpBody {
            let httpBodyData = try! JSONEncoder().encode(httpBody)
            urlRequest.httpBody = httpBodyData
        }
        
        print("start \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, err in
            if let err = err {
                if let _ = err as? URLError {
                    completion(Result<T.Response, ApiError>.failure(.network))
                    return
                }
                
                completion(Result<T.Response, ApiError>.failure(.response))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  let data = data else {
                completion(Result<T.Response, ApiError>.failure(.emptyResponse))
                return
            }
            
            // ログ
            let statusCode = response.statusCode
            print("ステーテスコード: \(statusCode)")
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("レスポンス: \(json)")
            }
            
            if (200...299).contains(statusCode) {
                // 成功
                do {
                    let object = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(Result<T.Response, ApiError>.success(object))
                } catch {
                    // 空レスポンスが成功の場合
                    if String(data: data, encoding: .utf8) == "" {
                        if let emptyResponse = EmptyResponse() as? T.Response {
                            completion(Result<T.Response, ApiError>.success(emptyResponse))
                            return
                        }
                    }
                    
                    completion(Result<T.Response, ApiError>.failure(.parse))
                }
            } else {
                // 失敗
                do {
                    let object = try JSONDecoder().decode(T.ErrorResponse.self, from: data)
                    completion(Result<T.Response, ApiError>.failure(.responseError(status: statusCode, data: object)))
                } catch {
                    completion(Result<T.Response, ApiError>.failure(.http(status: statusCode, data: data)))
                }
            }
        }
        
        task.resume()
    }
    
    func request<T: BaseApiRequest>(
        _ request: T
    ) -> AnyPublisher<Result<T.Response, ApiError>, Never> {
        return Future { promise in
            self.request(request) { result in
                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func request<T: BaseApiRequest>(
        _ request: T
    ) async -> Result<T.Response, ApiError> {
        return await withCheckedContinuation { continuation in
            self.request(request) { result in
                return continuation.resume(returning: result)
            }
        }
    }
}
