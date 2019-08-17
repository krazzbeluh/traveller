//
//  WeatherViewController.swift
//  Traveller
//
//  Created by Paul Leclerc on 31/07/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, SendWeatherStationDatasDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherStation.delegate = self
        refreshWeather()
        
//        setting up unitButton and reloadButton (image disposition and border)
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
    private var temperatureIsCelsius = true // var used to know if displayed temperature is in Celsius or Fahrenheit
    
    @IBOutlet weak var parisTemperature: UILabel!
    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var newYorkTemperature: UILabel!
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    internal func displayWeather(in city: City.CityName) {
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
    
    func displayWeather() {
        displayWeather(in: .paris)
        displayWeather(in: .newYork)
    }
    
    private func switchActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        reloadButton.isHidden = shown
    }
    
    var iconResponses = 0 { // this var is used to switch activityIndicator when all requests are ended
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
                func testResult(with result: Result<Void, Error>, for city: City) {
                    if case .failure(let error) = result {
                        self.showAlert(with: error)
                    }
                }
                
                self.weatherStation.getWeatherIcon(for: self.weatherStation.newYork) { result in
                    testResult(with: result, for: self.weatherStation.newYork)
                    self.displayWeather(in: .newYork)
                    self.iconResponses += 1
                }
                
                self.weatherStation.getWeatherIcon(for: self.weatherStation.paris) { result in
                    testResult(with: result, for: self.weatherStation.paris)
                    self.displayWeather(in: .paris)
                    self.iconResponses += 1
                }
            case .failure(let error):
                self.showAlert(with: error)
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
            displayWeather()
            unitButton.setImage(#imageLiteral(resourceName: "Celsius"), for: .normal)
        } else {
            temperatureIsCelsius = true
            displayWeather()
            unitButton.setImage(#imageLiteral(resourceName: "Farenheit"), for: .normal)
        }
        
    }
}
