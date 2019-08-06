//
//  NetworkService.swift
//  traveller
//
//  Created by Paul Leclerc on 06/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class NetworkService {
    init(url: String) {
        self.url = URL(string: url)!
    }
    
    var url: URL
    var networkSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    
    enum NetworkError: Error {
        case noData, error, responseNot200
    }
    
    func getData(callback: @escaping(Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = networkSession.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data else {
                    callback(.failure(.noData))
                    return
                }
                
                guard error == nil else {
                    callback(.failure(.error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.responseNot200))
                    return
                }
                
                callback(.success(data))
            }
            
        }
        task?.resume()
    }
}
