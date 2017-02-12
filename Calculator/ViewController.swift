//
//  ViewController.swift
//  Calculator
//
//  Created by Duc Le on 2/7/17.
//  Copyright © 2017 Duc Le Personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping = false; //Swift infers automatically the type is Bool
    
    @IBOutlet private weak var displayResult: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            displayResult.text = displayResult.text! + sender.currentTitle!
        } else {
            displayResult.text = sender.currentTitle!
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        set {
            displayResult.text = String(newValue)
        }
        get {
            return Double(displayResult.text!)!
        }
    }
    
    // Start using model to manage the operation
    // Using an object of CalculatorBrain
    private var brain =  CalculatorBrain() // Swift infered the type
    
    @IBAction private func mathOperations(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.takeOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false

        }
        if let mathematicsSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicsSymbol)
        }
        displayValue = brain.result
    }
}
