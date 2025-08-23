//
//  ValidationStepsView.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//

import SwiftUI

enum ValidationStepStatus {
    case pending
    case loading
    case success
    case failed
}

struct ValidationStep {
    let title: String
    let description: String
    var status: ValidationStepStatus
}

struct ValidationStepsView: View {
    @StateObject private var viewModel = ValidationViewModel()
    
    let componentCode: String
    let onAllStepsCompleted: () -> Void
    let onValidationFailed: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Validation Steps")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(Array(viewModel.steps.enumerated()), id: \.offset) { index, step in
                ValidationStepRow(
                    step: step,
                    stepNumber: index + 1
                )
            }
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .task {
                   await viewModel.startValidation(
                       with: componentCode,
                       onAllStepsCompleted: onAllStepsCompleted,
                       onValidationFailed: onValidationFailed
                   )
               }
    }
   
}

struct ValidationStepRow: View {
    let step: ValidationStep
    let stepNumber: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 步骤指示器
            stepIndicator
            
            // 步骤内容
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 状态指示器
            statusIndicator
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var stepIndicator: some View {
        ZStack {
            Circle()
                .fill(stepCircleColor)
                .frame(width: 24, height: 24)
            
            if step.status == .loading {
                ProgressView()
                    .scaleEffect(0.6)
                    .tint(.white)
            } else {
                Text("\(stepNumber)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(stepNumberColor)
            }
        }
    }
    
    @ViewBuilder
    private var statusIndicator: some View {
        switch step.status {
        case .pending:
            Image(systemName: "clock")
                .foregroundColor(.secondary)
        case .loading:
            ProgressView()
                .scaleEffect(0.8)
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .failed:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
    }
    
    private var stepCircleColor: Color {
        switch step.status {
        case .pending:
            return Color.secondary.opacity(0.3)
        case .loading:
            return Color.accentColor
        case .success:
            return Color.green
        case .failed:
            return Color.red
        }
    }
    
    private var stepNumberColor: Color {
        switch step.status {
        case .pending:
            return .secondary
        case .loading, .success, .failed:
            return .white
        }
    }
}

#Preview {
    ValidationStepsView(componentCode: "some sample code to validate") {
        print("All steps completed!")
    } onValidationFailed: {
        print("All steps failed!")
    }
}
