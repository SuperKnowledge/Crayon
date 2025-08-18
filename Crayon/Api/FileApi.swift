//
//  CrayonFileAPI.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//

// CrayonFileAPI.swift
// Swift HTTP API wrapper for crayon-backend file endpoints
// 适用于iOS/macOS，需替换 baseURL 和 token 获取方式

import Foundation

class FileApi: ApiProtocol {
    // 上传截图
    static func uploadScreenshot(fileURL: URL, appId: UUID, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("upload/screenshot")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        // 文件部分
        let filename = fileURL.lastPathComponent
        let fileData = try? Data(contentsOf: fileURL)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(fileData ?? Data())
        data.append("\r\n".data(using: .utf8)!)
        // app_id
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"app_id\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(appId.uuidString)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        URLSession.shared.dataTask(with: request) { d, _, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "upload", code: 0)))
            }
        }.resume()
    }

    // 上传资源
    static func uploadAsset(fileURL: URL, appId: UUID, assetType: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/upload/asset")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        // 文件部分
        let filename = fileURL.lastPathComponent
        let fileData = try? Data(contentsOf: fileURL)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        data.append(fileData ?? Data())
        data.append("\r\n".data(using: .utf8)!)
        // app_id
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"app_id\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(appId.uuidString)\r\n".data(using: .utf8)!)
        // asset_type
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"asset_type\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(assetType)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        URLSession.shared.dataTask(with: request) { d, _, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "upload", code: 0)))
            }
        }.resume()
    }

    // 获取 App 资源列表
    static func listAppAssets(appId: UUID, assetType: String? = nil, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        var url = baseURL.appending("/apps/\(appId.uuidString)/assets")
        guard var url = URL(string: baseURL) else { return }
        if let assetType = assetType {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = [URLQueryItem(name: "asset_type", value: assetType)]
            url = components.url!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, _, e in
            if let d = d, let arr = try? JSONSerialization.jsonObject(with: d) as? [[String: Any]] {
                completion(.success(arr))
            } else {
                completion(.failure(e ?? NSError(domain: "list", code: 0)))
            }
        }.resume()
    }

    // 获取文件元数据
    static func getFileMetadata(fileId: UUID, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = baseURL.appending("/\(fileId.uuidString)")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, _, e in
            if let d = d, let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                completion(.success(obj))
            } else {
                completion(.failure(e ?? NSError(domain: "meta", code: 0)))
            }
        }.resume()
    }

    // 删除文件
    static func deleteFile(fileId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = baseURL.appending("/\(fileId.uuidString)")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, r, e in
            if let response = r as? HTTPURLResponse, response.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(e ?? NSError(domain: "delete", code: 0)))
            }
        }.resume()
    }

    // 下载/访问文件
    static func downloadFile(filePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = baseURL.appending("/serve/\(filePath)")
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // 通常无需 token，若有权限控制可加
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { d, _, e in
            if let d = d {
                completion(.success(d))
            } else {
                completion(.failure(e ?? NSError(domain: "download", code: 0)))
            }
        }.resume()
    }
}
