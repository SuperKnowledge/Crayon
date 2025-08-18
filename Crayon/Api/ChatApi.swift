//
//  ChatApi.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//

import Foundation

// MARK: - Chat API 客户端
class ChatAPI:ApiProtocol {

    // 发送消息
    static func sendMessage(appId: String, message: String, screenshotUrl: String?, model: String?, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
        var urlString = "\(baseURL)/\(appId)/chat"
        if let model = model {
            urlString += "?model=\(model)"
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = ["message": message]
        if let screenshotUrl = screenshotUrl {
            body["screenshot_url"] = screenshotUrl
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                    completion(.success(chatResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 获取历史记录
    static func getConversationHistory(appId: String, versionId: String?, limit: Int = 50, offset: Int = 0, completion: @escaping (Result<ConversationHistory, Error>) -> Void) {
        var urlString = "\(baseURL)/\(appId)/chat/history?limit=\(limit)&offset=\(offset)"
        if let versionId = versionId {
            urlString += "&version_id=\(versionId)"
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let history = try JSONDecoder().decode(ConversationHistory.self, from: data)
                    completion(.success(history))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    // 清空历史记录
    static func clearConversationHistory(appId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/\(appId)/chat/history"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }

    // 获取单条消息
    static func getMessage(appId: String, messageId: String, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/\(appId)/chat/messages/\(messageId)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let message = try JSONDecoder().decode(MessageResponse.self, from: data)
                    completion(.success(message))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
