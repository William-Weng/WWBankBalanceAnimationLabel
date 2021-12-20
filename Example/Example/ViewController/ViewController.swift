//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/12/20.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWBankBalanceAnimationLabel

import UIKit
import WWPrint

final class ViewController: UIViewController {
    
    @IBOutlet weak var label1: WWBankBalanceAnimationLabel!
    @IBOutlet weak var label2: WWBankBalanceAnimationLabel!
    @IBOutlet weak var label3: WWBankBalanceAnimationLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func running(_ sender: UIBarButtonItem) {
        
        label1.balance(from: 0, to: 10000, format: "TWD. %.1f") { value in
            wwPrint(value)
        } completion: { isCompletion in
            wwPrint(isCompletion)
        }
        
        label2.balance(to: 20000, duration: 3.0, format: "CNY. %.1f", runloop: .current, forMode: .common)
        
        label3.balance(to: 30000, duration: 5.0, format: "USD. %.1f")
    }
}

