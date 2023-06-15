//
//  addingEventViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 23.05.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class addingEventViewController: UIViewController {

    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var processDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTxtField: UITextField!
    
    let db = Firestore.firestore()
    var titleTxt:String = ""
    var processDate:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var decription:String = ""
    var userName:String = ""
    var users : [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat
        timeFormatter.dateFormat = K.timeFormat
        processDate = dateFormatter.string(from: processDatePicker.date)
        startTime = timeFormatter.string(from: startTimePicker.date)
        endTime = timeFormatter.string(from: endTimePicker.date)
        
        
        
        
    }
    

    @IBAction func processDateValueChanged(_ sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = K.dateFormat
        self.processDate = dateFormater.string(from: sender.date)
    }
    
    
    @IBAction func startTimeValueChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = K.timeFormat
        self.startTime = timeFormatter.string(from: sender.date)
    }
    
    
    @IBAction func endTimeValueChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = K.timeFormat
        self.endTime = timeFormatter.string(from: sender.date)
    }
    
    
    @IBAction func etkinlikEkleButtonPressed(_ sender: UIButton) {
        if let titleTemp = titleTxtField.text , let descriptionTemp = descriptionTxtField.text  {
            
            self.db.collection(K.FStore.collectionNameEvents).addDocument(data: [
                "date" :
                    self.processDate,
                "description" : descriptionTemp ,
                "endTime" : self.endTime ,
                "startTime" : self.startTime ,
                "title" : titleTemp ,
                "user" : userName
                
                
            
            ]){ (error) in
                if let e = error {
                    print("Veri Firestore'a kaydedilirken bir sorun yaşandı.\(e.localizedDescription)")
                    let alert = UIAlertController(title: "Kaydedildi", message: "Etkinlik başarıyla kaydedildi", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Veri basariyla kaydedildi.")
                    
                    
                    self.navigationController?.popViewController(animated: true)

                    
                }
            }
        }
        
        
    }
    
    func getUsers() {
        users = []
        
        db.collection(K.FStore.collectionNameUsers).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e.localizedDescription)
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        
                        if let firstName = data[K.FStore.firstNameField] as? String , let lastName = data[K.FStore.lastNameField] as? String , let uID = data[K.FStore.uIDField] as? String {
                            let user = Users(uID: uID, firstName: firstName, lastName: lastName)
                            self.users.append(user)
                            
                            if let currentUser = Auth.auth().currentUser {
                                for user in self.users {
                                    if user.uID == currentUser.uid {
                                        self.userName = user.firstName+" "+user.lastName
                                        print(self.userName)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    
    
}
