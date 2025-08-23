//
//  ValidationViewModel.swift
//  Crayon
//
//  Created by leetao on 2025/8/23.
//


import SwiftUI
import Combine

@MainActor
class ValidationViewModel: ObservableObject {
    
    @Published var steps: [ValidationStep] = [
        ValidationStep(
            title: "Type Check",
            description: "Validating component structure and syntax",
            status: .pending
        ),
        ValidationStep(
            title: "Serialization",
            description: "Verifying component can be serialized properly",
            status: .pending
        )
    ]
    
    func startValidation(with componentCode: String, onAllStepsCompleted: @escaping () -> Void, onValidationFailed: @escaping () -> Void)  async  {
        // Reset all steps
        for i in 0..<steps.count {
            steps[i].status = .pending
        }
        
        Task {
            do {
                steps[0].status = .loading
                
                let result = try await ValidApi.validateComponent(code: componentCode)
                Log.info("validateComponent result:\(result)")
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                
                steps[0].status = result["typecheck"] == true ? .success : .failed
                
                // Start second step
                steps[1].status = .loading
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay to show loading
                
                // Update second step
                steps[1].status = result["serialize"] == true ? .success : .failed
                
                // Check for completion
                if steps.allSatisfy({ $0.status == .success }) {
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec delay before callback
                    onAllStepsCompleted()
                }
                
            } catch {
                // If any step fails, find the one that was loading and mark it as failed.
                if let loadingIndex = steps.firstIndex(where: { $0.status == .loading }) {
                    steps[loadingIndex].status = .failed
                }
                onValidationFailed()
            }
        }
    }
}
