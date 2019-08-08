//
//  SecondViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController, sendTranslatorDatasDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        translator.delegate = self
        
        translateButton.contentHorizontalAlignment = .fill
        translateButton.contentVerticalAlignment = .fill
        translateButton.imageView?.contentMode = .scaleAspectFill
        translateButton.layer.borderWidth = 10
        translateButton.layer.cornerRadius = translateButton.frame.width / 2
        translateButton.clipsToBounds = true
        translateButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    let translator = Translator()
    var textInFrench: String {
        return textToTranslate.text
    }
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        textToTranslate.resignFirstResponder()
    }
    
    func displayTranslation(_ translation: String) {
        translatedText.text = translation
    }
    
    func displayError(with type: Error) {
        switch type {
        default:
            sendAlert(message: "Erreur inconnue")
        }
    }
    
    @IBAction func translateText(_ sender: Any) {
        translator.textToTranslate = textToTranslate.text!
        translator.translate { result in
            switch result {
            case .success(let translation):
                self.displayTranslation(translation)
            case .failure(let error):
                self.displayError(with: error)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        hideKeyboard()
    }
}
