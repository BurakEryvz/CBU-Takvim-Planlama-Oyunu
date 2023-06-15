//
//  ViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 15.05.2023.
//

import UIKit
import CLTypingLabel //Kayan yazi olusturmak icin kullanilan Pod

class ViewController: UIViewController {

    @IBOutlet weak var cbuTakvimLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cbuTakvimLabel.text = K.appName
    }


}

