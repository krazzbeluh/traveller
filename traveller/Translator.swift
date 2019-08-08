//
//  Translator.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol sendTranslatorDatasDelegate: SharedController {
    var textInFrench: String {get}
}

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

class Translator {
    weak var delegate: sendTranslatorDatasDelegate?
    
    enum TranslationDataTaskError: Error {
        case unableToDecodeData
    }
    
    public var translationRequest: NetworkService?
    
    public var textToTranslate = "" {
        didSet {
            translationRequest = NetworkService(url: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyDya4uHyUQTvadV4wYczyzjYMUtrg-nSWo&source=fr&target=en&format=text&q=\(textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") //swiftlint:disable:this line_length
        }
    }
    
    public func translate(callback: @escaping(Result<String, Error>) -> Void) {
        translationRequest?.getData { result in
            switch result {
            case .success(let data):
                guard let translations = try? JSONDecoder().decode(GTranslateDecoder.self, from: data) else {
                    callback(.failure(TranslationDataTaskError.unableToDecodeData))
                    print("Error: Couldn't decode data into rates")
                    return
                }
                
                callback(.success(translations.data.translations[0].translatedText))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
