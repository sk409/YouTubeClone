import UIKit

struct Database {
    
    struct Response {
        static let succeeded = "SUCCEEDED"
        static let failed = "FAILED"
    }
    
    struct Key {
        static let userName = "user_name"
        static let password = "password"
    }
    
    struct Script {
        struct PHP {
            static let registerUser = "register_user.php"
            static let login = "login.php"
            static let fetchUser = "fetch_user.php"
            static let insertMovie = "insert_movie.php"
            static let concatMovieBlob = "concat_movie_blob.php"
            static let getMovieDataSize = "get_movie_data_size.php"
            static let fetchMovieDataBlob = "fetch_movie_data_blob.php"
        }
    }
    
    struct Result {
        var data: Data?
        var response: URLResponse?
        var error: Error?
    }
    
    static func fetchChannles() -> [Channel] {
        let v1 = Video(title: "Taylor Swift - Blank Space", thumbnailImage: UIImage(named: "taylor_swift_blank_space")!, numberOfViews: 1234567890)
        let v2 = Video(title: "Taylor Swift - Bad Blood featuring kendrick Lamar", thumbnailImage: UIImage(named: "taylor_swift_bad_blood")!, numberOfViews: 9876543210)
        let v3 = Video(title: "Taylor Swift - Bad Blood featuring kendrick Lamar", thumbnailImage: UIImage(named: "taylor_swift_bad_blood")!, numberOfViews: 9876543210)
        let v4 = Video(title: "Taylor Swift - Bad Blood featuring kendrick Lamar", thumbnailImage: UIImage(named: "taylor_swift_bad_blood")!, numberOfViews: 9876543210)
        let channel = Channel(name: "Taylor Swift", profileImage: UIImage(named: "taylor_swift_profile")!, videos: [v1, v2, v3, v4])
        return [channel]
    }
    
    static func sync(fileName: String, method: HTTPMethod, parameters: [URLQueryItem]) -> Result {
        var result = Result()
        let semaphore = DispatchSemaphore(value: 0)
        async(fileName: fileName, method: method, parameters: parameters) { data, response, error in
            defer {
                semaphore.signal()
            }
            result.data = data
            result.response = response
            result.error = error
        }
        semaphore.wait()
        return result
    }
    
    static func async(fileName: String, method: HTTPMethod, parameters: [URLQueryItem], completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        guard let urlRequest = makeURLRequest(fileName: fileName, method: method, parameters: parameters) else {
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                Debug.log(error.localizedDescription)
            }
            completion?(data, response, error)
        }.resume()
    }
    
    private static func makeURLRequest(fileName: String, method: HTTPMethod, parameters: [URLQueryItem]) -> URLRequest? {
        let urlString = "http://localhost/" + fileName
        switch method {
        case .get:
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = parameters
            if let url = urlComponents?.url {
                return URLRequest(url: url)
            }
        case .post:
            var urlComponents = URLComponents()
            urlComponents.queryItems = parameters
            if let url = URL(string: urlString), let httpBody = urlComponents.query {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = httpBody.data(using: .utf8)
                return urlRequest
            }
        }
        return nil
    }
    
}
