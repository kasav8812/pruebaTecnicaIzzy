//
//  WSManager.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import Foundation

class WSManager{
    private var activeRequests: [String: URLSessionDataTask] = [:]
    private let requestQueue = DispatchQueue(label: "NetworkRequestQueue")
    
    // MARK:
    func request<T: Encodable, R: Decodable>(
        url: String,
        method: HTTPMethod,
        body: T? = nil,
        headers: [String: String] = [:],
        completion: @escaping (Result<R, NetworkError>) -> Void
    ) {
        
        let requestKey = "\(method.rawValue)-\(url)-\(String(describing: body))"
        
        requestQueue.sync {
            if activeRequests[requestKey] != nil {
                return
            }
        }
        
        guard NetworkMonitor.shared.isConnected else {
            completion(.failure(.noInternet))
            
            NetworkMonitor.shared.onReconnect = { [weak self] in
                self?.request(url: url, method: method, body: body, headers: headers, completion: completion)
            }
            return
        }
        
        var urlRequest: URLRequest!
        
        if method == .GET {
            guard var components = URLComponents(string: url) else {
                completion(.failure(.invalidURL))
                return
            }
            
            if let body = body {
                components.queryItems = QueryEncoder.encode(body)
            }
            
            guard let finalURL = components.url else {
                completion(.failure(.invalidURL))
                return
            }
            
            urlRequest = URLRequest(url: finalURL)
            
        } else {
            guard let finalURL = URL(string: url) else {
                completion(.failure(.invalidURL))
                return
            }
            
            urlRequest = URLRequest(url: finalURL)
            urlRequest.httpMethod = method.rawValue
            
            if let body = body {
                do {
                    urlRequest.httpBody = try JSONEncoder().encode(body)
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    completion(.failure(.unknown))
                    return
                }
            }
        }
        
        headers.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            defer {
                self?.requestQueue.sync {
                }
            }
            
            if let error = error as? URLError {
                
                if error.code == .notConnectedToInternet {
                    DispatchQueue.main.async {
                        completion(.failure(.noInternet))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.failure(.connection(error)))
                }
                return
            }
            
            guard let http = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard (200...299).contains(http.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.http(status: http.statusCode, data: data)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(R.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decoding(error)))
                }
            }
        }
        
        requestQueue.sync {
            activeRequests[requestKey] = task
        }
        
        task.resume()
    }
}

// MARK:
struct QueryEncoder {
    static func encode<T: Encodable>(_ value: T) -> [URLQueryItem] {
        let mirror = Mirror(reflecting: value)
        return mirror.children.compactMap { child in
            guard let key = child.label else { return nil }
            return URLQueryItem(name: key, value: "\(child.value)")
        }
    }
}

// MARK:
enum NetworkError: Error {
    case invalidURL
    case connection(Error)
    case http(status: Int, data: Data?)
    case decoding(Error)
    case unknown
    case noInternet
}

// MARK:
enum HTTPMethod: String {
    case GET
    case POST
}
