//
//  AuthenticationManager.swift
//  Crayon
//
//  Created by leetao on 2025/8/19.
//

import Combine
import Foundation

class AuthenticationManager: ObservableObject {
    @Published var useId: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String? = nil
    @Published var errorMessage: String? = nil

    func login(email: String) {
        UserApi.createUser(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonObject):
                    if let registeredUserId = jsonObject["id"] as? String {
                        self?.useId = registeredUserId
                        self?.userEmail = email
                        self?.isLoggedIn = true
                    } else {
                        self?.errorMessage = "The data of reponse is not correct"
                    }

                case .failure(let error):
                    Log.error("注册失败: \(error.localizedDescription)")
                    self?.errorMessage = "Login failed"
                }
            }
        }
    }

    // 模拟登出
    func logout() {
        useId = nil
        userEmail = nil
        isLoggedIn = false
    }
}
