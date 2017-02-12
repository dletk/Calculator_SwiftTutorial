//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Duc Le on 2/9/17.
//  Copyright © 2017 Duc Le Personal. All rights reserved.
//

import Foundation

// Function adding for the calculator, to put it in a enum type, it needs to be
// global function (outside the class)
func adding(first: Double, second: Double) -> Double {
    return first+second
}

class CalculatorBrain {
    private var accumulator = 0.0
    
    func takeOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UniaryOperation(sqrt),
        "Cos": Operation.UniaryOperation(cos),
        "Sin": Operation.UniaryOperation(sin),
        "±": Operation.UniaryOperation({-$0}), // Change the size of the number
        "+": Operation.BinaryOperation({ (op1: Double, op2: Double) -> Double in return op1+op2}), // This is a default way to declare inlined function
        "-": Operation.BinaryOperation({(op1, op2) in return op1-op2}), //We do not need the type becasuse based on the declaration of Operation.Bina..., Swift can infer its type
        "x": Operation.BinaryOperation({return $0*$1}), // $0, $1, $2... is the deafault argument, so we don't need to name the argument op1, op2.
        "÷": Operation.BinaryOperation({$0/$1}), // Swift will know the return value is a Double
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UniaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let valueConstant):
                accumulator = valueConstant
            case .UniaryOperation(let aFunction):
                accumulator = aFunction(accumulator)
            case .BinaryOperation(let aFunction):
                executePendingOperation()
                pending = PendingBinaryOperationInfo(binaryOperationFunction: aFunction, firstOperands: accumulator)
            case .Equals:
                executePendingOperation()
            }
        }
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator = pending!.binaryOperationFunction(pending!.firstOperands, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryOperationFunction: (Double, Double) -> Double
        var firstOperands: Double
    }
    
    var result: Double {
        // Read-only variable
        get {
            return accumulator
        }
    }
}

