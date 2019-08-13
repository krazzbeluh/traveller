//
//  Shared.swift
//  traveller
//
//  Created by Paul Leclerc on 08/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import UIKit

protocol DisplayAlert: UIViewController {
    func showAlert(with type: Error)
}

extension UIViewController: DisplayAlert {
    func showAlert(with type: Error) {
        let message: String
        switch type {
        case NetworkService.NetworkError.noData:
            message = "Impossible de mettre à jour le taux de change"
        case NetworkService.NetworkError.error:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case NetworkService.NetworkError.responseNot200:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case Converter.ConvertError.unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case Converter.ConvertError.APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case Converter.ConvertError.noChangeRateInData:
            message = "Impossible de mettre à jour le taux de change"
        case Converter.ConvertError.notANumber:
            message = "Le texte entré n'est pas un nombre"
        case Translator.TranslationDataTaskError.unableToDecodeData:
            message = "Une erreur est survenue lors de la récupération de la traduction"
        case WeatherStation.WeatherDataTaskError.unableToDecodeData:
            message = "Une erreur est survenue lors de la récupération de la météo"
        default:
            message = "Erreur: Inconnue (\(type))"
        }
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
