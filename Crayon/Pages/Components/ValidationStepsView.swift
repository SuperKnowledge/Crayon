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
    @State private var steps: [ValidationStep] = [
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
    
    let onAllStepsCompleted: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Validation Steps")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
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
    }
    
    func startValidation(with componentCode: String) {
        // 重置所有步骤状态
        for i in 0..<steps.count {
            steps[i].status = .pending
        }
        
        // 开始第一步：Type Check
        steps[0].status = .loading
        
        Task {
            do {
                let result = try await ValidApi.validateComponent(code: componentCode)
                
                await MainActor.run {
                    // 更新 Type Check 结果
                    steps[0].status = result["typecheck"] == true ? .success : .failed
                    
                    // 开始第二步：Serialization
                    steps[1].status = .loading
                    
                    // 延迟一点来显示加载状态
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        steps[1].status = result["serialize"] == true ? .success : .failed
                        
                        // 检查是否所有步骤都成功
                        if steps.allSatisfy({ $0.status == .success }) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                onAllStepsCompleted()
                            }
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    // 如果验证失败，标记当前正在进行的步骤为失败
                    for i in 0..<steps.count {
                        if steps[i].status == .loading {
                            steps[i].status = .failed
                            break
                        }
                    }
                }
            }
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
    ValidationStepsView {
        print("All steps completed!")
    }
}
