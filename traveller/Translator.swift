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
    func displayTranslation(with text: String)
}

class Translator {
    weak static var delegate: sendTranslatorDatasDelegate?
    
    public static var textToTranslate: String {
        return delegate?.textInFrench.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    static func translate(_ text: String) {
        TranslationService().getTranslation { result in
            switch result {
            case .success(let translation):
                self.delegate?.displayTranslation(with: translation)
                print(translation)
            case .failure(let error):
                print(error)
            }
        }
    }
}
