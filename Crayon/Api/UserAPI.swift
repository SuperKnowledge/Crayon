//
//  CrayonUserAPI.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//


import Foundation

struct UserApi:ApiProtocol {
    let baseURL: URL
    let token: String // Bearer Token

    // 创建用户
    static func createUser(email: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "createUser", code: 0)))
            }
        }.resume()
    }

    // 获取当前用户信息
    static func getCurrentUser(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/me")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "getCurrentUser", code: 0)))
            }
        }.resume()
    }

    // 通过 ID 获取用户
    static func getUser(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/\(userId)")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "getUser", code: 0)))
            }
        }.resume()
    }

    // 获取当前用户的所有 app
    static func listMyApps(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let url = baseURL.appending("/me/apps")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let arr = try? JSONSerialization.jsonObject(with: d) as? [[String: Any]] {
                completion(.success(arr))
            } else {
                completion(.failure(e ?? NSError(domain: "listMyApps", code: 0)))
            }
        }.resume()
    }

    // 删除当前用户
    static func deleteCurrentUser(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = baseURL.appending("/me")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, r, e in
            if let response = r as? HTTPURLResponse, response.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(e ?? NSError(domain: "deleteCurrentUser", code: 0)))
            }
        }.resume()
    }
}
