//
//  CalendarViewController.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 15.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class CalendarViewController: UIViewController{

    @IBOutlet weak var label: UILabel!
    let db = Firestore.firestore()
    var users : [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        loadUsers()
        
        
            
        }
    
    
    func loadUsers(){
        users = []
        
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            self.users = []
            
            if let e = error {
                print("Veritabından veri çekilirken sorun oluştu.\(e.localizedDescription)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        if let firstName = data["firstName"] as? String , let lastName =  data["lastName"] as? String, let uID = data["uID"] as? String{
                            let newUser = Users(uID: uID, firstName: firstName, lastName: lastName)
                            self.users.append(newUser)
                            
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.getUsers()
                        self.getFirebaseUser()
                    }
                }
            }
        }
    }
    
    func getUsers(){
        for user in self.users {
            print("--------------------------------------------------------")
            print("Name: \(user.firstName)\nSurname: \(user.lastName)\nID: \(user.uID)\n")
            print("--------------------------------------------------------")
        }
    }
    
    
    func getFirebaseUser(){
        for user in self.users {
            if let firebaseUID = Auth.auth().currentUser?.uid as? String {
                if firebaseUID == user.uID {
                    self.label.text = user.firstName+" "+user.lastName
                }
            }
        }
    }
    
    
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print("Error signing out : %@",signOutError)
        }
    }
    
    
    }


    

    
    
    


