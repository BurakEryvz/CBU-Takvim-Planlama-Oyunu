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
import FSCalendar


class CalendarViewController: UIViewController , FSCalendarDelegate{

    
    var events : [Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet var calendar : FSCalendar!
    
    let cellSpacingHeight: CGFloat = 5
    let db = Firestore.firestore()
    var users : [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        title = K.appName
        
        
        loadUsers()
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.dataSource = self
        calendar.delegate = self
        }
    
    
    
    
    
    func loadUsers(){
        users = []
        
        db.collection(K.FStore.collectionNameUsers).addSnapshotListener { querySnapshot, error in
            self.users = []
            
            if let e = error {
                print("Veritabından veri çekilirken sorun oluştu.\(e.localizedDescription)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        if let firstName = data[K.FStore.firstNameField] as? String , let lastName =  data[K.FStore.lastNameField] as? String, let uID = data[K.FStore.uIDField] as? String{
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
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        formatter.dateFormat = K.dateFormat
        let stringDate = formatter.string(from: date)
        
        print(stringDate)
        eventleriGoster(date: stringDate)
        
    }
    
    
    
    func eventleriGoster(date:String) {
        
        events = []
        
        db.collection(K.FStore.collectionNameEvents).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for document in snapshotDocuments {
                        let data = document.data()
                        
                        if let tarih = data["date"] as? String , let title = data["title"] as? String ,  let description = data["description"] as? String , let endTime = data["endTime"] as? String , let startTime = data["startTime"] as? String , let user = data["user"] as? String{
                            
                            if date == tarih {
                                let newEvent = Event(date: tarih, description: description, endTime: endTime, startTime: startTime, title: title, user: user)
                                self.events.append(newEvent)
                                self.tableView.reloadData()
                                
                            }
                            else{
                                
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    }




    



extension CalendarViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! EventCell
       
        cell.konuLabel.text = event.title
        cell.gonderenLabel.text = "Ekleyen : "+event.user
        cell.aciklamaLabel.text = "Açıklama : "+event.description
        cell.saatLabel.text = event.startTime+" - "+event.endTime
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,  editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        events.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        tableView.endUpdates()
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
    


