//
//  FirstViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController, sendConverterDatasDelegate {
    
    private let converter = Converter()
    @IBOutlet weak var moneyInEuro: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        converter.delegate = self
        converter.getChangeRateValue{ () in }
        
        convertButton.contentHorizontalAlignment = .fill
        convertButton.contentVerticalAlignment = .fill
        convertButton.imageView?.contentMode = .scaleAspectFill
        convertButton.layer.borderWidth = 10
        convertButton.layer.cornerRadius = convertButton.frame.width / 2
        convertButton.clipsToBounds = true
        convertButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToConverterDetail" {
            let successVC = segue.destination as! ConverterDetailViewController
            successVC.converter = converter
        }
    }

    func displayDollar() {
        result.text = String(converter.moneyInDollar!)
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
    @IBAction func infosButton() {
        performSegue(withIdentifier: "segueToConverterDetail", sender: self)
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
    
    func sendAlert(with type: Error) {
        let message: String
        switch type {
        case NetworkService.NetworkError.noData:
            message = "Impossible de mettre à jour le taux de change"
        case NetworkService.NetworkError.error:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case NetworkService.NetworkError.responseNot200:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case ChangeRateService.ChangeRateDataTaskError.unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case ChangeRateService.ChangeRateDataTaskError.APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case ChangeRateService.ChangeRateDataTaskError.noChangeRateInData:
            message = "Impossible de mettre à jour le taux de change"
        default:
            message = "Erreur: Inconnue"
        }
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
