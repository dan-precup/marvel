//
//  NetworkService.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Combine
import CryptoKit
import Foundation

enum APIError: Error {
    case generic
    case unauthorised
    case badRequest(code: Int, error: Error?)
    case timeout
    case server(code: Int, error: Error?)
    case decoding
    case parsing(Error?)
    case unknown(Error?)

}

protocol NetworkService {
    func request<T: Decodable>(from endpoint: NetworkEndpoint, decodingTo: T.Type) -> AnyPublisher<T, APIError>
}

final class NetworkServiceImpl: NetworkService {
    private let publicKey = "5ba3a348b1bcf94d616279390e00c82e"
    private let privateKey = "5988398be5b8ed9e2f377c08cb50d414dd054640"
    private let jsonDecoder = JSONDecoder()
    /// Singleton instance
    static let shared = NetworkServiceImpl()
    private init() {}
    
    func request<T: Decodable>(from endpoint: NetworkEndpoint, decodingTo: T.Type) -> AnyPublisher<T, APIError> {
        URLSession.shared
            .dataTaskPublisher(for: buildRequest(with: endpoint))
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError({ [weak self] error in self?.handleErrorMaping(error, endpoint: endpoint) ?? APIError.unknown(error) })
            .eraseToAnyPublisher()
        
    }
    
    /// Build a request using the endpoint data
    /// - Parameter endpoint: The endpoint
    /// - Returns: The URLRequest
    private func buildRequest(with endpoint: NetworkEndpoint) -> URLRequest {
        var queryItems = endpoint.queryItems
        queryItems.append(contentsOf: buildAuthQueryItems())
        var request = URLRequest(url: endpoint.url.apending(queryItems),
                                 cachePolicy: endpoint.caching,
                                 timeoutInterval: endpoint.timeout)
        request.httpMethod = endpoint.method.rawValue
        request.addValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Accept")
        
        return request
    }
    
    
    /// Handle the data response
    /// - Parameters:
    ///   - data: Received data
    ///   - response: The url response
    /// - Returns: The data if response is valid
    private func handleResponse(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResp = response as? HTTPURLResponse else { throw APIError.generic }
        let error = try? jsonDecoder.decode(ErrorResponse.self, from: data)
        switch httpResp.statusCode {
        case 200..<300:
            return data
        case 401, 403:
            Log.error("API AUTH Error HTTP code: \(httpResp.statusCode), URL: \(httpResp.url?.absoluteString ?? "-")", error)
            throw APIError.unauthorised
        case 404..<500:
            Log.error("API BAD REQUEST Error HTTP code: \(httpResp.statusCode), URL: \(httpResp.url?.absoluteString ?? "-")", error)
            throw APIError.badRequest(code: httpResp.statusCode, error: error)
        case 504:
            Log.error("API TIMEOUT Error HTTP code: \(httpResp.statusCode), URL: \(httpResp.url?.absoluteString ?? "-")", error)
            throw APIError.timeout
        case 500..<600:
            Log.error("API SERVER Error HTTP code: \(httpResp.statusCode), URL: \(httpResp.url?.absoluteString ?? "-")", error)
            throw APIError.server(code: httpResp.statusCode, error: error)
        default:
            Log.error("API UNKNOWN Error HTTP code: \(httpResp.statusCode), URL: \(httpResp.url?.absoluteString ?? "-")", error)
            throw APIError.generic
        }
    }
    
    /// Detail error mapping
    /// - Parameters:
    ///   - error: The received error
    ///   - endpoint: The endpoint
    /// - Returns: The error converted into an APIError
    func handleErrorMaping(_ error: Error, endpoint: NetworkEndpoint) -> APIError {
            Log.error("API Error on endpoint \(endpoint), \(endpoint.url.absoluteString)", error)
          if let error = error as? DecodingError {
              return .parsing(error)
          } else if let error = error as? APIError {
              return error
          } else {
              return .unknown(error)
          }
      }
    
    /// Builds the auth data
    /// - Returns: The auth query items
    private func buildAuthQueryItems() -> [URLQueryItem] {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let hashString = "\(timestamp)\(privateKey)\(publicKey)"
        let hash = Insecure.MD5
            .hash(data: hashString.data(using: .utf8)!)
            .map{String(format: "%02x", $0)}
            .joined()
        return [
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "ts", value: "\(timestamp)"),
            URLQueryItem(name: "apikey", value: publicKey)
        ]
    }
}
