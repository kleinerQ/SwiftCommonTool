//
//  ViewController.swift
//  20191018_swiftCommonTool
//
//  Created by Yen on 2019/10/18.
//  Copyright © 2019 com.pacify.mplatform. All rights reserved.
//

import UIKit

class ViewController: SwipeRightDismissViewcontroller {

    @IBOutlet weak var testTextView: UITextView!
    @IBOutlet weak var test2TextField: UITextField!
    @IBOutlet weak var testTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testTextField.tag = 101
        self.test2TextField.tag = self.testTextField.tag + 1
        SwiftCommonTool.addKeyboardButtonWithTextField(textField: self.testTextField)
        SwiftCommonTool.addKeyboardButtonWithTextView(textView: testTextView)
        SwiftCommonTool.addKeyboardButtonWithTextField(textField: self.testTextField, upButton: nil, downButton: #selector(downAction(sender:)))
        SwiftCommonTool.addKeyboardButtonWithTextField(textField: self.test2TextField, upButton: #selector(upAction(sender:)), downButton: #selector(downAction(sender:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func upAction(sender:UITextField){
        let previousTag = sender.tag - 1
        SwiftCommonTool.jumpToNextTextField(textField: sender, withTag: previousTag)
        print("up")
    }
    @objc func downAction(sender:UITextField){
        let nextTag = sender.tag + 1
        SwiftCommonTool.jumpToNextTextField(textField: sender, withTag: nextTag)
        print("down")
    }

}

