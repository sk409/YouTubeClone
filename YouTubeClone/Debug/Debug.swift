

struct Debug {
    
    static func log(_ string: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("=========================================================")
        print("File: \(file) - Function: \(function) - Line: \(line)")
        print(string)
    }
    
}
