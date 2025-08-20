//
//  AppApi.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//

import Foundation

class AppApi: ApiProtocol {
    // MARK: - 创建 App
    static func createApp(name: String, description: String, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["name": name, "description": description]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }

    // MARK: - 获取 App 详情
    static func getApp(appId: String, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(appId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }

    // MARK: - 获取 App 列表
    static func listApps(page: Int, pageSize: Int, search: String?, token: String, completion: @escaping (Data?, Error?) -> Void) {
        var urlString = "\(baseURL)?page=\(page)&page_size=\(pageSize)"
        if let search = search, !search.isEmpty {
            urlString += "&search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }

    // MARK: - 更新 App
    static func updateApp(appId: String, name: String?, description: String?, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(appId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        var body: [String: Any] = [:]
        if let name = name { body["name"] = name }
        if let description = description { body["description"] = description }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }

    // MARK: - 删除 App
    static func deleteApp(appId: String, token: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(appId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            completion(error)
        }.resume()
    }

    // MARK: - 获取 App 代码
    static func getAppCode(appId: String, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(appId)/code") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }
    
    // MARK: - 获取我使用的 App 列表
    static func getAppsIUse(bookmarkedOnly: Bool, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/using?bookmarked_only=\(bookmarkedOnly)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }
    
    // MARK: - 切换书签状态
    static func toggleBookmark(publicationId: String, isBookmarked: Bool, token: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/using/\(publicationId)/bookmark") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["is_bookmarked": isBookmarked]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { _, _, error in
            completion(error)
        }.resume()
    }
    
    // MARK: - 从"我使用的 App"中移除
    static func removeFromUsedApps(publicationId: String, token: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/using/\(publicationId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { _, _, error in
            completion(error)
        }.resume()
    }
}
