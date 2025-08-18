import Foundation

struct VersionApi:ApiProtocol{
    // 获取版本历史
    static func listVersions(appId: String, limit: Int? = nil, offset: Int = 0, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var url = baseURL.appending("/\(appId)/versions")
        guard var url = URL(string: url) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var queryItems = [URLQueryItem(name: "offset", value: "\(offset)")]
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        components.queryItems = queryItems
        url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "listVersions", code: 0)))
            }
        }.resume()
    }

    // 获取当前版本
    static func getCurrentVersion(appId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/\(appId)/versions/current")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "getCurrentVersion", code: 0)))
            }
        }.resume()
    }

    // 获取指定版本
    static func getVersion(appId: String, versionNumber: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/\(appId)/versions/\(versionNumber)")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "getVersion", code: 0)))
            }
        }.resume()
    }

    // 回滚到某个版本
    static func rollbackVersion(appId: String, versionNumber: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/\(appId)/rollback")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["version_number": versionNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "rollbackVersion", code: 0)))
            }
        }.resume()
    }

    // 比较两个版本
    static func compareVersions(appId: String, v1: Int, v2: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var url = baseURL.appending("/\(appId)/compare-versions")
        guard let url = URL(string: url) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "v1", value: "\(v1)"),
            URLQueryItem(name: "v2", value: "\(v2)")
        ]
        url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "compareVersions", code: 0)))
            }
        }.resume()
    }

    // 获取组件请求统计
    static func getComponentRequests(appId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let url = baseURL.appending("/\(appId)/component-requests")
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let arr = try? JSONSerialization.jsonObject(with: d) as? [[String: Any]] {
                completion(.success(arr))
            } else {
                completion(.failure(e ?? NSError(domain: "getComponentRequests", code: 0)))
            }
        }.resume()
    }

    // 从某个版本创建分支
    static func createBranch(appId: String, versionNumber: Int, branchName: String?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var url = baseURL.appending("/\(appId)/versions/\(versionNumber)/branch")
        guard var url = URL(string: url) else { return }
        if let branchName = branchName {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = [URLQueryItem(name: "branch_name", value: branchName)]
            url = components.url!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { d, r, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "createBranch", code: 0)))
            }
        }.resume()
    }
}
