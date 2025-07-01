//
//  Person.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import Foundation

struct Person: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var details: String
    var dob: Date
    var sex: String
    var contact: String
    var experience: Int
    var skills: [String]
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 0
    }
    
    var formattedDOB: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }
    
    static let sample = Person(
        name: "John Doe",
        details: "iOS Developer",
        dob: Calendar.current.date(byAdding: .year, value: -30, to: Date())!,
        sex: "Male",
        contact: "john@example.com",
        experience: 5,
        skills: ["Swift", "UIKit", "SwiftUI"]
    )
}