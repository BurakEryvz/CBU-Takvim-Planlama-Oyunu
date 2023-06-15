//
//  LoginViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 15.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth



class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var sifreTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func girisYapButtonPressed(_ sender: UIButton) {
        
        
        
        
        if let email = emailTxtField.text , let sifre = sifreTxtField.text {
            
            Auth.auth().signIn(withEmail: email, password: sifre) { authResult , error in
                
                if let e = error {
                    
                    let hataMesaji = "\(e.localizedDescription)"
                    let dialogMessage = UIAlertController(title: "HATA!", message: hataMesaji, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true,completion: nil)
                    
                } else {
                    
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
}
