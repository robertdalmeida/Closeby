import Foundation

enum NetworkRequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unexpectedStatusCode
    case underlyingError(Error)
}

/// Anyone who wishes to send a network request should conform to this protocol - This can be mocked
protocol HTTPClientProtocol {
    func sendRequest<T: Decodable>(endpoint: NetworkRequestProtocol, responseModel: T.Type) async -> Result<T, NetworkRequestError>
}

extension HTTPClientProtocol {
    func sendRequest<T: Decodable>(endpoint: NetworkRequestProtocol, responseModel: T.Type) async -> Result<T, NetworkRequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        var queryParameters: [URLQueryItem]?
        if let params = endpoint.queryParameters {
            queryParameters = params.map { (key: String, value: String) in
                URLQueryItem(name: key, value: value)
            }
        }
        urlComponents.queryItems = queryParameters
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.underlyingError(error))
        }
    }
}
