//
//  Constants.swift
//  cbuTakvim
//
//  Created by Burak Eryavuz on 17.05.2023.
//

import Foundation


//Projedeki string olarak kullanilan bazi değerlerin tekrarlanmamasi icin olusturulmustur.
struct K {
    
    static let appName = "CBU Takvim"
    static let registerSeque = "RegisterToCalendar"
    static let loginSegue = "LoginToCalendar"
    static let eventsSegue = "calendarToEvents"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "EventCell"
    static let dateFormat = "yyyy-MM-dd"
    static let timeFormat = "HH:mm"
    
    struct FStore {
        static let collectionNameUsers = "Users"
        static let collectionNameEvents = "events"
        static let firstNameField = "firstName"
        static let lastNameField = "lastName"
        static let uIDField = "uID"
    }
    
    
    
}
