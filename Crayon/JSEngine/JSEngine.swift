//
//  JSEngine.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//


import JavaScriptCore

class JSEngine {
    private var context = JSContext()!

    init() {
        // Catch exceptions from JS
        context.exceptionHandler = { context, exception in
            Log.error("JS Error: \(exception?.toString() ?? "Unknown error")")
        }
    }

    // Function to run a script that generates our UI JSON
    func generateUIJson(from script: String, with data: [String: Any]) -> String? {
        context.evaluateScript(script)


        guard let renderFunction = context.objectForKeyedSubscript("render") else { return nil }

        // Call the JS function, passing in our business data
        // The JS function will return a JSON object (as a JSValue)
        guard let result = renderFunction.call(withArguments: [data]), !result.isUndefined else { return nil }

        // Convert the JS JSON object back to a Swift Dictionary/String
        if let jsonObject = result.toObject(), JSONSerialization.isValidJSONObject(jsonObject) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                return String(data: jsonData, encoding: .utf8)
            } catch {
                Log.error("Error converting JS object to JSON string: \(error)")
                return nil
            }
        }
        return nil
    }
}
