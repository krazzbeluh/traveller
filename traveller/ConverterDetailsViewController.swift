//
//  ConverterDetailsViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 05/08/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ConverterDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        changeRateText.text = "1 € = \(Converter.changeRate) $"
        dateText.text = "Taux au \(dateFormatter.string(from: Converter.changeRateDay)) :"
        switchActivityIndicator(shown: false)
    }
    
//    var converter: Converter
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "FR-fr")
        
        return formatter
    }
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var changeRateText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    func switchActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        refreshButton.isHidden = shown
    }
    
    @IBAction func reloadCurrency(_ sender: Any) {
//        converter.getChangeRateValue()
        switchActivityIndicator(shown: true)
    }
}
