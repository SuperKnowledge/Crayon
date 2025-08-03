//
//  responsible.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//


import Foundation
import Combine

final class ActionHandler: ObservableObject {

    static let shared = ActionHandler()
    
    // MARK: - Navigation Publisher
    // We use a PassthroughSubject from Combine to broadcast navigation events.
    // The main view will listen to this publisher to update its navigation state.
    // The <String, Never> means it sends String values and never fails.
    let navigationSubject = PassthroughSubject<String, Never>()

    // Private init to enforce the singleton pattern
    private init() {}

    // MARK: - Main Handler Method
    
    /// Takes a UIAction and executes the corresponding logic.
    /// - Parameter action: The action object received from the JSON.
    public func handle(_ action: UIAction) {
        // Use a switch to handle different action types defined in your JSON
        switch action.type {
            
        case "API_CALL":
            handleApiCall(payload: action.payload)
            
        case "NAVIGATE":
            handleNavigation(payload: action.payload)
            
        case "OPEN_URL":
            handleOpenURL(payload: action.payload)

        default:
            Log.error("ActionHandler: Received unknown action type '\(action.type)'")
        }
    }

    // MARK: - Private Action Implementations

    private func handleApiCall(payload: [String: String]?) {
        guard let urlString = payload?["url"], let method = payload?["method"] else {
            Log.debug("ActionHandler Error: API_CALL is missing 'url' or 'method' in payload.")
            return
        }
        
        Log.debug("Performing API Call...")
        Log.debug("Method: \(method)")
        Log.debug("URL: \(urlString)")
        
        /// TODO
        
    }
    
    private func handleNavigation(payload: [String: String]?) {
        guard let destination = payload?["destination"] else {
            Log.error("ActionHandler Error: NAVIGATE is missing 'destination' in payload.")
            return
        }
        
        Log.info("Navigating to destination: \(destination)")
        
        navigationSubject.send(destination)
    }

    private func handleOpenURL(payload: [String: String]?) {
        guard let urlString = payload?["url"], let _ = URL(string: urlString) else {
            Log.error("ActionHandler Error: OPEN_URL has an invalid 'url' in payload.")
            return
        }

        Log.info("Opening URL: \(urlString)")
        
        /// TODO
    }
}
