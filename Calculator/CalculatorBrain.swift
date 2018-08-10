//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by InSynchro M SDN BHD on 08/08/2018.
//  Copyright © 2018 Tarun Bhutani. All rights reserved.
//

import Foundation

func multiply(val1:Double, val2:Double) -> Double {
    return val1 * val2
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand : Double)  {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    
    var operation = ["Ω" : Operations.Constant(M_PI), //M_PI,
                     "e" : Operations.Constant(M_E), //M_E,
                     "±" : Operations.UnaryOperation({ -$0}),
                     "√" : Operations.UnaryOperation(sqrt),
                     "cos": Operations.UnaryOperation(cos),
                     "✕" : Operations.BinaryOperation({ $0 * $1 }),
                     "÷" : Operations.BinaryOperation({ $0 / $1 }),
                     "+" : Operations.BinaryOperation({ $0 + $1 }),
                     "-" : Operations.BinaryOperation({ $0 - $1 }),
                     "=" : Operations.Equals
    ]
    
    
    enum Operations {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol : String)  {
        internalProgram.append(symbol as AnyObject)
        if let operation = operation[symbol] {
            switch operation{
                case .Constant(let value):
                    accumulator =  value
                
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                
                case .BinaryOperation(let funcation):
                    executePendingOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: funcation, firstOperand: accumulator)
                
                case .Equals:
                    executePendingOperation()
            }
        }
    }
    
    private func executePendingOperation() {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending:PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program:PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for ops in arrayOfOps{
                    if let operand = ops as? Double{
                        setOperand(operand: operand)
                    }else if let operation = ops as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear()  {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    var result:Double {
        get{
            return accumulator
        }
    }
}
