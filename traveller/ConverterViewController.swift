//
//  FirstViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

// Design : https://dribbble.com/shots/4816296-Stylish-Currency-Converter-iOS-app

import UIKit

class ConverterViewController: UIViewController, sendConverterDatasDelegate {
    
    private let converter = Converter()
    @IBOutlet weak var moneyInEuro: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var changeRateText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        converter.delegate = self
        converter.getChangeRateValue()
        // Do any additional setup after loading the view.
    }

    func displayDollar(with value: String) {
        result.text = value
    }
    
    private func hideKeyboard() {
        moneyInEuro.resignFirstResponder()
    }
    
    @IBAction func convertyButton(_ sender: Any) {
        convert()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        convert()
    }
    
    private func convert() {
        do {
            try converter.convert(moneyInEuro.text)
        } catch let error as Converter.ConvertError {
            print(error)
        } catch {
            fatalError("Oops ! Something went wrong !")
        }
    }
    
    func displayChangeRate() {
        convert()
    }
    
    func sendAlert(with type: ChangeRateService.ChangeRateDataTaskError) {
        let message: String
        switch type {
        case .noData:
            message = "Impossible de mettre à jour le taux de change"
        case .error:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case .responseNot200:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case .unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case .APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case .noChangeRateInData:
            message = "Impossible de mettre à jour le taux de change"
        }
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
