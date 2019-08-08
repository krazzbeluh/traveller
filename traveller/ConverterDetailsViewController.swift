//
//  ConverterDetailsViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 05/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ConverterDetailViewController: UIViewController, SharedController {
    override func viewDidLoad() {
        super.viewDidLoad()
        changeRateText.text = "1 € = \(converter.changeRate) $"
        dateText.text = "Taux au \(dateFormatter.string(from: converter.changeRateDay)) :"
        switchActivityIndicator(shown: false)
        
        refreshButton.contentHorizontalAlignment = .fill
        refreshButton.contentVerticalAlignment = .fill
        refreshButton.imageView?.contentMode = .scaleAspectFit
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "FR-fr")
        
        return formatter
    }
    
    var converter: Converter!
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var changeRateText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private func switchActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        refreshButton.isHidden = shown
    }
    
    func displayChangeRate() {
        changeRateText.text = "1 € = \(converter.changeRate) $"
        dateText.text = "Taux au \(dateFormatter.string(from: converter.changeRateDay)) :"
    }
    
    @IBAction func reloadCurrency(_ sender: Any) {
        converter.getChangeRateValue { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                self.sendAlert(with: error)
            }
            self.displayChangeRate()
            self.switchActivityIndicator(shown: false)
        }
        switchActivityIndicator(shown: true)
    }
}
