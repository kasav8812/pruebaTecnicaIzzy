//
//  WSManager.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import Foundation

class WSManager{
    
    private let session: URLSession
    private var retryQueue: [() async -> Void] = []
    private let maxRetries = 3
    static let shared = WSManager()
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.waitsForConnectivity = true
        session = URLSession(configuration: configuration)
        
        setupReconnectListener()
    }
    
    func request<T: Codable, R: Codable>(url: String, method: HTTPMethod, body: T? = nil, headers: [String: String] = [:],retries: Int = 0) async -> Result<R, NetworkError> {
        guard let url = URL(string: url) else {
            return .failure(.invalidURL)
        }
        
        if !NetworkMonitor.shared.isConnected {
            enqueueForRetry {
                let _ : Result<R, NetworkError> = await self.request(url: url.absoluteString,method: method, body: body, headers: headers)
            }
            return .failure(.noConnection)
        }
        
        var request = URLRequest(url: url)
        
        if method == .GET {
            guard var components = URLComponents(string: url.absoluteString) else {
                return .failure(.invalidURL)
            }
            
            if let body = body {
                components.queryItems = QueryEncoder.encode(body)
            }
            
            guard let finalURL = components.url else {
                return .failure(.invalidURL)
            }
            
            request = URLRequest(url: finalURL)
            print("=======================================================")
            print("Request API ", method.rawValue)
            print(request)
            print("=======================================================")
        }else{
            request.httpMethod = method.rawValue
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
            
            print("=======================================================")
            print("Request API ", method.rawValue)
            print(request)
            // Body
            if let body = body {
                do {
                    printRequestJson(body: body)
                    request.httpBody = try JSONEncoder().encode(body)
                    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    return .failure(.encodingError)
                }
            }
           
        }
        
          
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknown(NSError()))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                return .failure(.httpError(statusCode: httpResponse.statusCode))
            }
            
            do {
                let decoded = try JSONDecoder().decode(R.self, from: data)
                return .success(decoded)
            } catch {
                return .failure(.decodingError)
            }
            
        } catch let error as URLError {
            
            if error.code == .timedOut {
                if retries < maxRetries {
                    return await self.request( url: url.absoluteString, method: method, body: body, headers: headers,retries: retries + 1)
                }
                return .failure(.timeout)
            }
            
            if error.code == .notConnectedToInternet {
                enqueueForRetry {
                    let _ : Result<R, NetworkError> = await self.request(url: url.absoluteString, method: method, body: body, headers: headers)
                }
                return .failure(.noConnection)
            }
            
            return .failure(.unknown(error))
            
        } catch {
            return .failure(.unknown(error))
        }
    }
    
}
private extension WSManager {
    
    func setupReconnectListener() {
        NetworkMonitor.shared.onReconnect = { [weak self] in
            guard let self = self else { return }
            
            Task {
                for task in self.retryQueue {
                    await task()
                }
                self.retryQueue.removeAll()
            }
        }
    }
    
    func enqueueForRetry(_ block: @escaping () async -> Void) {
        retryQueue.append(block)
    }
    
    func printRequestJson<T : Codable>(body: T) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(body)
            let jsonString = String(data: data, encoding: .utf8)
            print("Request Body")
            print(jsonString ?? "Error converting to String")
            print("=======================================================")
        } catch {
            print("Encoding error:", error)
        }
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

struct EmptyRequest: Encodable {}
struct EmptyResponse: Decodable {}

// MARK:
enum NetworkError: Error {
    case invalidURL
    case invalidParameters
    case encodingError
    case decodingError
    case timeout
    case noConnection
    case httpError(statusCode: Int)
    case unknown(Error)
}

// MARK:
enum HTTPMethod: String {
    case GET
    case POST
}
