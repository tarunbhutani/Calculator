//
//  ViewController.swift
//  Calculator
//
//  Created by InSynchro M SDN BHD on 07/08/2018.
//  Copyright © 2018 Tarun Bhutani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Widget Initialization
    @IBOutlet var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var displayValue : Double{
        get {
            return Double(display.text!)!
        }
        set {
            self.display.text = String(newValue)
        }
    }
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = self.display.text!
            self.display.text = textCurrentlyInDisplay + digit
        }else{
            self.display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalOperation = sender.currentTitle{
            brain.performOperation(symbol: mathematicalOperation)
        }
        displayValue = brain.result
        
    }
    
    var saveProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        saveProgram = brain.program
    }
    
    @IBAction func restore() {
        if saveProgram != nil{
            brain.program = saveProgram!
            displayValue = brain.result
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

