//
//  TranslationService.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

// MARK: - Welcome
fileprivate struct GTranslateDecoder: Codable {
    let data: DataClass
}

// MARK: - DataClass
fileprivate struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
fileprivate struct Translation: Codable {
    let translatedText: String
}

class TranslationService {
    static var shared = TranslationService()
    private init() {}
    
    private static let url = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyDya4uHyUQTvadV4wYczyzjYMUtrg-nSWo&source=fr&target=en&format=text&q=" //swiftlint:disable:this line_length
    private var task: URLSessionDataTask?
    private var gTranslateSession = URLSession(configuration: .default)
    
    init(gTranslateSession: URLSession) {
        self.gTranslateSession = gTranslateSession
    }
    
    enum TranslationDataTaskError: Error {
        case noData, error, responseNot200, unableToDecodeData, noTranslationInData
    }
    
    func getTranslation(callback: @escaping (Result<String, TranslationDataTaskError>) -> Void) {
        let gTranslateUrl = URL(string: "\(TranslationService.url)\(Translator.textToTranslate)")!
        var request = URLRequest(url: gTranslateUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = gTranslateSession.dataTask(with: request) { (data, response, error) -> Void in
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
                
                guard let translations = try? JSONDecoder().decode(GTranslateDecoder.self, from: data) else {
                    callback(.failure(.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                guard let translation: String = translations.data.translations[0].translatedText else {
                    callback(.failure(.noTranslationInData))
                    return
                }
                
                callback(.success(translation))
            }
        }
        task?.resume()
    }
}
