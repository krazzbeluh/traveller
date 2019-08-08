//
//  FirstViewController.swift
//  traveller
//
//  Created by Paul Leclerc on 23/06/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController, SharedController, sendConverterDatasDelegate {
    
    private let converter = Converter()
    @IBOutlet weak var moneyInEuro: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        converter.delegate = self
        converter.getChangeRateValue { _ in }
        
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
            sendAlert(with: error)
        } catch {
            fatalError("Oops ! Something went wrong !")
        }
    }
    
    func displayChangeRate() {
        convert()
    }
}
