//
//  NetworkingClient.swift
//  Redux
//
//  Created by Daniel Garcia on 14.03.21.
//

import Foundation

struct Networking {
    let urlSession: URLSession = .shared
    
    func getCurrencies(_ completion: @escaping (Swift.Result<[CurrencyList.Currency], NetworkingError>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://api.frankfurter.app/currencies")!)
        urlRequest.httpMethod = "GET"
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(.goodOldGenericError))
                return
            }
            
            if
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let currencies = json as? [String: String] {
                let currencies = currencies.map { CurrencyList.Currency(fullName: $1, code: $0) }
                
                completion(.success(currencies))
            } else {
                completion(.failure(.goodOldGenericError))
            }
            
            
        }.resume()
    }
}

enum NetworkingError: Error, LocalizedError {
    case goodOldGenericError
    
    public var errorDescription: String {
        switch self {
        case .goodOldGenericError:
            return "Something is funky!"
        }
    }
}
