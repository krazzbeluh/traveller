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
        
        Translator.delegate = self
        
        translateButton.contentHorizontalAlignment = .fill
        translateButton.contentVerticalAlignment = .fill
        translateButton.imageView?.contentMode = .scaleAspectFill
        translateButton.layer.borderWidth = 10
        translateButton.layer.cornerRadius = translateButton.frame.width / 2
        translateButton.clipsToBounds = true
        translateButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    var textInFrench: String {
        return textToTranslate.text
    }
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    func hideKeyboard() {
        textToTranslate.resignFirstResponder()
    }
    
    func displayTranslation(with text: String) {
        translatedText.text = text
    }
    
    @IBAction func translateText(_ sender: Any) {
        Translator.translate(textToTranslate.text!)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        hideKeyboard()
    }
}
