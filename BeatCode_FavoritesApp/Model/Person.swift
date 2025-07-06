//
//  Person.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//

import SwiftData
import SwiftUI

@Model
final class Person {
    var id: UUID
    var name: String
    var isFavorite: Bool
    var details: String
    var dob: Date
    var sex: String
    var contact: String
    var experience: Int
    var skills: [String]
    
    init(name: String, isFavorite: Bool, details: String, dob: Date, sex: String,
         contact: String, experience: Int, skills: [String]) {
        self.id = UUID()
        self.name = name
        self.isFavorite = isFavorite
        self.details = details
        self.dob = dob
        self.sex = sex
        self.contact = contact
        self.experience = experience
        self.skills = skills
    }
    
    var initials: String {
        name.components(separatedBy: " ")
            .compactMap { $0.first?.uppercased() }
            .joined()
    }
    
    var formattedDOB: String {
        dob.formatted(date: .abbreviated, time: .omitted)
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 0
    }
}
