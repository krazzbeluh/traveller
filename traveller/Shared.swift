//
//  Shared.swift
//  traveller
//
//  Created by Paul Leclerc on 08/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import UIKit

protocol SharedController: UIViewController {
    func sendAlert(with type: Error)
}

extension SharedController {
    func sendAlert(with type: Error) {
        let message: String
        switch type {
        case NetworkService.NetworkError.noData, WeatherIconService.WeatherIconDataTaskError.noData:
            message = "Impossible de mettre à jour le taux de change"
        case NetworkService.NetworkError.error, WeatherIconService.WeatherIconDataTaskError.error:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case NetworkService.NetworkError.responseNot200, WeatherIconService.WeatherIconDataTaskError.responseNot200:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case ChangeRateService.ChangeRateDataTaskError.unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case ChangeRateService.ChangeRateDataTaskError.APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour du taux de change"
        case ChangeRateService.ChangeRateDataTaskError.noChangeRateInData:
            message = "Impossible de mettre à jour le taux de change"
        case Converter.ConvertError.notANumber:
            message = "Le texte entré n'est pas un nombre"
        case Translator.TranslationDataTaskError.unableToDecodeData:
            message = "Une erreur est survenue lors de la récupération de la traduction"
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
