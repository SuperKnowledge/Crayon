//
//  Log.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//


import Foundation
import os // 导入统一日志系统框架

/// 一个全局、统一的日志记录器，封装了苹果的 os.Logger。
///
/// 使用方法:
/// ```
/// Log.info("用户登录成功")
/// Log.debug("获取到的数据是: \(data)")
/// Log.error("网络请求失败: \(error.localizedDescription)", category: .network)
/// ```
struct Log {
    
    // MARK: - Log Categories
    
    /// 定义日志的分类，方便在控制台 App 中筛选。
    enum Category: String {
        case general = "General"    // 通用
        case ui = "UI"              // UI 相关
        case network = "Network"    // 网络请求
        case database = "Database"  // 数据库
        case location = "Location"  // 定位服务
    }
    
    // MARK: - Private Implementation
    
    /// 子系统标识符，通常使用 App 的 Bundle ID。
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.duck.leetao.Crayon"

    /// 存储不同类别的 Logger 实例，避免重复创建。
    private static var loggers: [String: Logger] = [:]

    private static func logger(for category: Category) -> Logger {
        let categoryRawValue = category.rawValue
        if let existingLogger = loggers[categoryRawValue] {
            return existingLogger
        } else {
            let newLogger = Logger(subsystem: subsystem, category: categoryRawValue)
            loggers[categoryRawValue] = newLogger
            return newLogger
        }
    }
    
    /// 格式化日志消息，自动包含文件、函数和行号。
    private static func formatMessage(
        _ message: Any,
        file: String,
        function: String,
        line: UInt
    ) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(fileName):\(line)] \(function) -> \(message)"
    }
    
    // MARK: - Public Logging Methods

    /// 记录调试信息。仅在 DEBUG 模式下有效。
    /// 用于开发过程中的详细信息追踪。
    static func debug(
        _ message: Any,
        category: Category = .general,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        #if DEBUG
        let formattedMessage = formatMessage(message, file: file, function: function, line: line)
        logger(for: category).debug("\(formattedMessage)")
        #endif
    }
    
    /// 记录参考信息。
    /// 用于记录程序正常运行时的关键节点信息。
    static func info(
        _ message: Any,
        category: Category = .general,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        let formattedMessage = formatMessage(message, file: file, function: function, line: line)
        logger(for: category).info("\(formattedMessage)")
    }

    /// 记录警告信息。
    /// 用于记录可能出现问题，但不影响程序继续运行的情况。
    static func warning(
        _ message: Any,
        category: Category = .general,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        let formattedMessage = formatMessage(message, file: file, function: function, line: line)
        logger(for: category).warning("\(formattedMessage)")
    }
    
    /// 记录错误信息。
    /// 用于记录可恢复的错误，例如网络请求失败。
    static func error(
        _ message: Any,
        category: Category = .general,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        let formattedMessage = formatMessage(message, file: file, function: function, line: line)
        logger(for: category).error("\(formattedMessage)")
    }
    
    /// 记录严重错误或故障。
    /// 用于记录导致程序崩溃或无法继续运行的严重问题。
    static func fault(
        _ message: Any,
        category: Category = .general,
        file: String = #file, function: String = #function, line: UInt = #line
    ) {
        let formattedMessage = formatMessage(message, file: file, function: function, line: line)
        logger(for: category).fault("\(formattedMessage)")
    }
}
