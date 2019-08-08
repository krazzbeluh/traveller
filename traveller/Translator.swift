//
//  Translator.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol sendTranslatorDatasDelegate: class {
    var textInFrench: String {get}
    func displayTranslation()
}

class Translator {
    weak static var delegate: sendTranslatorDatasDelegate?
    
    public static var textToTranslate: String?
    public static var translatedText: String? {
        didSet {
            self.delegate?.displayTranslation()
        }
    }
    
    public static func translate(_ text: String) {
        textToTranslate = text
        TranslationService().getTranslation { result in
            switch result {
            case .success(let translation):
                translatedText = translation
            case .failure(let error):
                print(error)
            }
        }
    }
}
