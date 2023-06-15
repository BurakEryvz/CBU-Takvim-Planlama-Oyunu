//
//  ViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 15.05.2023.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {

    @IBOutlet weak var cbuTakvimLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cbuTakvimLabel.text = K.appName
    }


}

