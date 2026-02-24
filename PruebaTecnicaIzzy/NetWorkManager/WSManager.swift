//
//  WSManager.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import Foundation

class WSManager{
    // MARK:
    func request<T: Encodable, R: Decodable>(url: String, method: HTTPMethod, body: T? = nil, headers: [String: String] = [:], completion: @escaping (Result<R, NetworkError>) -> Void)
    {
        var request : URLRequest!
        if method == .GET {
            guard var components = URLComponents(string: url) else {
                completion(.failure(.invalidURL))
                return
            }
            if let request = body {
                components.queryItems = QueryEncoder.encode(request)
            }
            
            guard let finalURL = components.url else {
                completion(.failure(.invalidURL))
                return
            }
            request = URLRequest(url: finalURL)
            headers.forEach {
                request.setValue($1, forHTTPHeaderField: $0)
            }
        }else{
            guard let url = URL(string: url) else {
                completion(.failure(.invalidURL))
                return
            }
            
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            if let body = body {
                do {
                    request.httpBody = try JSONEncoder().encode(body)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    print("Request Input", request as Any)
                } catch {
                    completion(.failure(.unknown))
                    return
                }
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
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
            
        }.resume()
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
}

// MARK:
enum HTTPMethod: String {
    case GET
    case POST
}
