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
        
        unitButton.contentHorizontalAlignment = .fill
        unitButton.contentVerticalAlignment = .fill
        unitButton.imageView?.contentMode = .scaleAspectFill
        unitButton.layer.borderWidth = 10
        unitButton.layer.cornerRadius = unitButton.frame.width / 2
        unitButton.clipsToBounds = true
        unitButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    private let weatherStation = WeatherStation()
    private var temperatureIsCelsius = true
    
    @IBOutlet weak var parisTemperature: UILabel!
    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var newYorkTemperature: UILabel!
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var unitButton: UIButton!
    
    func displayWeather(in city: City.CityName) {
        switch city {
        case .paris:
            let temperature: String
            if temperatureIsCelsius {
                temperature = "\(weatherStation.paris.temperature) °C"
            } else {
                temperature = "\(weatherStation.paris.temperatureF) °F"
            }
            parisTemperature.text = temperature
            if let iconData = weatherStation.paris.weatherIcon {
                parisIcon.image = UIImage(data: iconData)
            }
        case .newYork:
            let temperature: String
            if temperatureIsCelsius {
                temperature = "\(weatherStation.newYork.temperature) °C"
            } else {
                temperature = "\(weatherStation.newYork.temperatureF) °F"
            }
            newYorkTemperature.text = temperature
            if let iconData = weatherStation.newYork.weatherIcon {
                newYorkIcon.image = UIImage(data: iconData)
            }
        }
    }
    
    func sendAlert(with type: NetworkService.NetworkError) {
        let message: String
        switch type {
        case .noData:
            message = "Impossible de mettre à jour la météo"
        case .error:
            message = "Une erreur est survenue lors de la mise à jour de la météo"
        case .responseNot200:
            message = "Une erreur est survenue lors de la mise à jour de la météo"
        /*case .unableToDecodeData:
            message = "Impossible de mettre à jour le taux de change"
        case .APINoSuccess:
            message = "Une erreur est survenue lors de la mise à jour de la météo"*/
        }
        print(type)
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) {
        let alertVC = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton() {
        weatherStation.refreshWeather()
    }
    
    @IBAction func switchDegreesUnit(_ sender: Any) {
        if temperatureIsCelsius {
            temperatureIsCelsius = false
            parisTemperature.text = "\(weatherStation.paris.temperatureF) °F"
            newYorkTemperature.text = "\(weatherStation.newYork.temperatureF) °F"
            unitButton.setImage(#imageLiteral(resourceName: "Celsius"), for: .normal)
        } else {
            temperatureIsCelsius = true
            parisTemperature.text = "\(weatherStation.paris.temperature) °C"
            newYorkTemperature.text = "\(weatherStation.newYork.temperature) °C"
            unitButton.setImage(#imageLiteral(resourceName: "Farenheit"), for: .normal)
        }
        
    }
}
