//
//  WeatherViewController.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, sendWeatherStationDatasDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherStation.delegate = self
        weatherStation.refreshWeather()
        
    }
    
    private let weatherStation = WeatherStation()
    private var temperatureIsCelsius = true
    
    @IBOutlet weak var parisTemperature: UILabel!
    @IBOutlet weak var newYorkTemperature: UILabel!
    
    func displayWeather(in city: City) {
        switch city.name {
        case .paris:
            parisTemperature.text = "\(weatherStation.paris.temperature) °C"
        case .newYork:
            newYorkTemperature.text = "\(weatherStation.newYork.temperature) °C"
        }
    }
    
    func sendAlert(with type: WeatherService.WeatherDataTaskError) {
        let message: String
        switch type {
        case .noData:
            message = "Impossible de mettre à jour la météo"
        case .error:
            message = "Une erreur est survenue lors de la mise à jour de la météo"
        case .responseNot200:
            message = "Une erreur est survenue lors de la mise à jour de la météo"
        case .unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case .APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour de la météo"
        }
        print(type)
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func switchDegreesUnit(_ sender: Any) {
        if temperatureIsCelsius {
            temperatureIsCelsius = false
            parisTemperature.text = "\(weatherStation.paris.temperatureF) °F"
            newYorkTemperature.text = "\(weatherStation.newYork.temperatureF) °F"
        } else {
            temperatureIsCelsius = true
            parisTemperature.text = "\(weatherStation.paris.temperature) °C"
            newYorkTemperature.text = "\(weatherStation.newYork.temperature) °C"
        }
        
    }
}
