//
//  SecondViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController, SendTranslatorDatasDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        translator.delegate = self
        
        //        setting up convertButton displaay (image disposition and borders)
        translateButton.contentHorizontalAlignment = .fill
        translateButton.contentVerticalAlignment = .fill
        translateButton.imageView?.contentMode = .scaleAspectFill
        translateButton.layer.borderWidth = 10
        translateButton.layer.cornerRadius = translateButton.frame.width / 2
        translateButton.clipsToBounds = true
        translateButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    let translator = Translator()
    internal var textInFrench: String {
        return textToTranslate.text
    }
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    func hideKeyboard() {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        hideKeyboard()
    }
    
    func displayTranslation(_ translation: String) {
        translatedText.text = translation
    }
    
    @IBAction func translateText(_ sender: Any) {
        translator.textToTranslate = textToTranslate.text!
        translator.translate { result in
            switch result {
            case .success(let translation):
                self.displayTranslation(translation)
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }
    
}
