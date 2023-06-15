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
        
        // Geri düğmesini gizler.
        navigationItem.hidesBackButton = true
        
        title = K.appName
        
        // Kullanıcıları yükleme işlemini başlatır.
        loadUsers()
        
        // TableView için özel hücreyi tanımlayan nib'i ve hücre tanımlayıcısını kaydeder.
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.dataSource = self
        calendar.delegate = self
        }
    
    
    
    
    
    // Bu fonksiyon, Firebase veritabanından kullanıcıları yüklemek için kullanılır.
    func loadUsers(){
        users = []
        
        // Firestore veritabanındaki "users" koleksiyonunu dinleyerek anlık güncellemeleri alır.
        db.collection(K.FStore.collectionNameUsers).addSnapshotListener { querySnapshot, error in
            self.users = []
            
            if let e = error {
                print("Veritabından veri çekilirken sorun oluştu.\(e.localizedDescription)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        
                        // Veritabanından alınan verilerin uygun tiplere dönüştürülmesi.
                        if let firstName = data[K.FStore.firstNameField] as? String , let lastName =  data[K.FStore.lastNameField] as? String, let uID = data[K.FStore.uIDField] as? String{
                            
                            // Yeni bir Users nesnesi oluşturulur.
                            let newUser = Users(uID: uID, firstName: firstName, lastName: lastName)
                            
                            // Oluşturulan kullanıcı, "users" dizisine eklenir.
                            self.users.append(newUser)
                            
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.getFirebaseUser()
                    }
                }
            }
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
    
    
    // Bu fonksiyon, FSCalendar delegesi tarafından çağrıldığında, bir tarih seçildiğinde gerçekleştirilecek işlemleri belirtir.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr")
        formatter.dateFormat = K.dateFormat
        let stringDate = formatter.string(from: date)
        
        print(stringDate)
        // eventleriGoster() fonksiyonu çağrılarak, belirtilen tarihteki etkinliklerin gösterilmesi sağlanır.
        eventleriGoster(date: stringDate)
        
    }
    
    
    // Bu fonksiyon, belirli bir tarihe sahip olan etkinlikleri göstermek için kullanılır.
    func eventleriGoster(date:String) {
        
        // events dizisini boşaltarak önceki etkinlikleri temizler.
        events = []
        
        // Firestore veritabanındaki "events" koleksiyonunu dinler ve anlık değişiklikleri algılar.
        db.collection(K.FStore.collectionNameEvents).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for document in snapshotDocuments {
                        let data = document.data()
                        
                        // Veritabanından alınan verilerin uygun tiplere dönüştürülmesi.
                        if let tarih = data["date"] as? String , let title = data["title"] as? String ,  let description = data["description"] as? String , let endTime = data["endTime"] as? String , let startTime = data["startTime"] as? String , let user = data["user"] as? String{
                            
                            
                            // Belgenin tarihi, istenen tarihe eşitse, yeni bir Event nesnesi oluşturulur.
                            if date == tarih {
                                let newEvent = Event(date: tarih, description: description, endTime: endTime, startTime: startTime, title: title, user: user)
                                // Oluşturulan etkinlik, events dizisine eklenir.
                                self.events.append(newEvent)
                                // TableView'nin yeniden yüklenmesi, görüntüyü günceller.
                                self.tableView.reloadData()
                                
                            }
                            else{
                                // Tarih eşleşmiyorsa, yine de TableView'nin yeniden yüklenmesi yapılır.
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
    
    //bu fonksiyon events dizisindeki eleman sayisi kadar tabloda satir olusturur.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {// Bu fonksiyon, belirli bir indexPath'e sahip bir UITableViewCell döndürmek için kullanılır.
        
        // events dizisinden, indexPath.row değerine sahip olan olayı alır.
        let event = events[indexPath.row]
        
        // K.cellIdentifier olarak tanımlanan bir hücre tanımlayıcısı kullanılır.
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! EventCell
       
        // Hücredeki etiketlere olayın özelliklerini atar.
        cell.konuLabel.text = event.title
        cell.gonderenLabel.text = "Ekleyen : "+event.user
        cell.aciklamaLabel.text = "Açıklama : "+event.description
        cell.saatLabel.text = event.startTime+" - "+event.endTime
        
        // Oluşturulan hücreyi döndürür.
        return cell
    }
    
    func tableView(_ tableView: UITableView,  editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {  // Fonksiyon, bir hücrenin silme işlemi gerçekleştirildiğinde ilgili işlemleri yapar.
        tableView.beginUpdates()
        events.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        tableView.endUpdates()
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
    


