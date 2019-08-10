//
//  WeatherViewController.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, SharedController, sendWeatherStationDatasDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherStation.delegate = self
        refreshWeather()
        
        unitButton.contentHorizontalAlignment = .fill
        unitButton.contentVerticalAlignment = .fill
        unitButton.imageView?.contentMode = .scaleAspectFill
        unitButton.layer.borderWidth = 10
        unitButton.layer.cornerRadius = unitButton.frame.width / 2
        unitButton.clipsToBounds = true
        unitButton.layer.borderColor = UIColor(named: "Blue")?.cgColor
        
        reloadButton.contentHorizontalAlignment = .fill
        reloadButton.contentVerticalAlignment = .fill
        reloadButton.imageView?.contentMode = .scaleAspectFit
        
        switchActivityIndicator(shown: true)
    }
    
    private let weatherStation = WeatherStation()
    private var temperatureIsCelsius = true
    
    @IBOutlet weak var parisTemperature: UILabel!
    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var newYorkTemperature: UILabel!
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    private func switchActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        reloadButton.isHidden = shown
    }
    
    var iconResponses = 0 {
        didSet {
            if self.iconResponses == 2 {
                switchActivityIndicator(shown: false)
                self.iconResponses = 0
            }
        }
    }
    private func refreshWeather() {
        weatherStation.refreshWeather { result in
            switch result {
            case .success:
                func testResult(with result: Result<Void, Error>, for city: City) -> Data {
                    switch result {
                    case .success:
                        return city.weatherIcon!
                    case .failure(let error):
                        self.sendAlert(with: error)
                    }
                    return Data()
                }
                
                self.weatherStation.getWeatherIcon(for: self.weatherStation.newYork) { result in
                    self.newYorkIcon.image = UIImage(data: testResult(with: result, for: self.weatherStation.newYork))
                    self.iconResponses += 1
                }
                
                self.weatherStation.getWeatherIcon(for: self.weatherStation.paris) { result in
                    self.parisIcon.image = UIImage(data: testResult(with: result, for: self.weatherStation.paris))
                    self.iconResponses += 1
                }
            case .failure(let error):
                self.sendAlert(with: error)
            }
        }
    }
    
    @IBAction func refreshButton() {
        switchActivityIndicator(shown: true)
        refreshWeather()
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
