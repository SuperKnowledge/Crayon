//
//  ApiError.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//

import Foundation


// 定义一些自定义错误，方便调试
enum ApiError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case unexpectedPayload
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let error):
            return "The network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Received an invalid response from the server (e.g., non-200 status code)."
        case .decodingError(let error):
            return "Failed to decode the JSON response: \(error.localizedDescription)"
        case .unexpectedPayload:
            return "The response payload did not match the expected TypeCheck or Serialize result structure."
        }
    }
}

struct ValidApi {
    
    /// 发送组件代码到服务器进行验证，并确定响应的类型。
    ///
    /// - Parameter componentCode: 要验证的组件代码字符串，例如 "<U>xxx</U>"
    /// - Returns: 一个字典 `["typecheck": Bool, "serialize": Bool]`。
    ///   - 如果是 TypeCheck 结果，`typecheck` 的值是 `isValid` 的结果，`serialize` 为 `false`。
    ///   - 如果是 Serialize 结果，`serialize` 的值表示序列化是否成功 (`json` 字段非 `nil`)，`typecheck` 为 `false`。
    /// - Throws: `ApiError` 如果请求或解析过程中出现问题。
    static func validateComponent(code: String) async throws -> [String: Bool] {
     
        guard let url = URL(string: "http://localhost:3000/api/valid") else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ComponentRequestBody(componentCode: code)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw ApiError.requestFailed(error)
        }
        
      
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ApiError.invalidResponse
        }
        
    
        let decodedResponse: ApiResponse
        do {
            decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        } catch {
            throw ApiError.decodingError(error)
        }
        
        let payload = decodedResponse.any
        

        if let isValid = payload.isValid {
            return [
                "typecheck": isValid,
                "serialize": false
            ]
        }
        
      
        if payload.json != nil || payload.stateManager != nil {
            let serializationSuccess = payload.json != nil
            return [
                "typecheck": false,
                "serialize": serializationSuccess
            ]
        }
        
        // 如果两种情况都不是，说明响应格式不符合预期
        throw ApiError.unexpectedPayload
    }
    
}
