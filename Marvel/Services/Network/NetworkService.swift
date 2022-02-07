//
//  NetworkService.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Combine
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
    func request<T: Codable>(from endpoint: NetworkEndpoint, decodingTo: T.Type) -> AnyPublisher<T, APIError>
}

final class NetworkServiceImpl: NetworkService {
    private let jsonDecoder = JSONDecoder()
    
    /// The cache service
    private let cacheService: CacheService
    
    /// Singleton instance
    static let shared = NetworkServiceImpl()
    private init(cacheService: CacheService = ServiceRegistry.shared.cacheService) {
        self.cacheService = cacheService
    }
    
    func request<T: Codable>(from endpoint: NetworkEndpoint, decodingTo: T.Type) -> AnyPublisher<T, APIError> {
        if let value: T = getCachedEntityIfExists(forKey: endpoint.localCacheSignature) {
            return Just(value).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: buildRequest(with: endpoint))
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError({ [weak self] error in self?.handleErrorMaping(error, endpoint: endpoint) ?? APIError.unknown(error) })
            .map({ [weak self] decodedData in
                self?.setCache(forKey: endpoint.localCacheSignature, entity: decodedData)
                return decodedData
            })
            .eraseToAnyPublisher()
    }
    
    
    /// Set the cache using a given encodable entity
    private func setCache<T: Codable>(forKey key: String?, entity: T) {
        guard let cacheKey = key,
                let encodedData = try? JSONEncoder().encode(entity) else { return }
        cacheService.setCachedData(forKey: cacheKey, data: encodedData)
    }
    
    /// Get the existing cache if possible
    /// - Returns: The entity or nil if nothing found
    private func getCachedEntityIfExists<T: Codable>(forKey key: String?) -> T? {
        guard let cacheKey = key,
            let data = cacheService.getCachedDataIfNotExpired(forKey: cacheKey),
              let decoded = try? jsonDecoder.decode(T.self, from: data) else  {
            return nil
        }
        return decoded
    }
    
    /// Build a request using the endpoint data
    /// - Parameter endpoint: The endpoint
    /// - Returns: The URLRequest
    private func buildRequest(with endpoint: NetworkEndpoint) -> URLRequest {
        var request = URLRequest(url: endpoint.url.apending(endpoint.queryItems),
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
}
