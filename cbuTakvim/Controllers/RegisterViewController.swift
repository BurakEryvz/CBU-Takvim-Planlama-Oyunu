//
//  RegisterViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 15.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var isimTxtField: UITextField!
    @IBOutlet weak var soyisimTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var sifreTxtField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func kaydolButtonPressed(_ sender: UIButton) {
        
        if let email = emailTxtField.text , let sifre = sifreTxtField.text , let isim = isimTxtField.text , let soyisim = soyisimTxtField.text {
            
            Auth.auth().createUser(withEmail: email, password: sifre) { authResult, error in
                
                if let e = error {
                    
                    let hataMesaji = "\(e.localizedDescription)"
                    var dialogMessage = UIAlertController(title: "HATA!", message: hataMesaji, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true,completion: nil)
                }
                else{
                    
                    let user = Auth.auth().currentUser
        
                    if user != nil  {
                        
                        self.db.collection(K.FStore.collectionNameUsers).addDocument(data: [
                            "firstName" : isim ,
                            "lastName" : soyisim ,
                            "uID" : user?.uid 
                        
                        ]){ (error) in
                            if let e = error {
                                print("Veri Firestore'a kaydedilirken bir sorun yaşandı.\(e.localizedDescription)")
                            }else{
                                print("Veri basariyla kaydedildi.")
                            }
                        }
                    }
                    self.performSegue(withIdentifier: K.registerSeque, sender: self) //Kosullar karsilanirsa Calender view'e gecis saglaniyorç
                }
            }
        }
    }
    

}
