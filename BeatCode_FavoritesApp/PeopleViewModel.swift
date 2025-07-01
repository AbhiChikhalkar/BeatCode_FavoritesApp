//
//  PeopleViewModel.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = [
        Person(name: "Abhishek Chikhalkar", isFavorite: false, details: "Developer",
              dob: Calendar.current.date(byAdding: .year, value: -30, to: Date())!,
              sex: "Male", contact: "abhishek@example.com", experience: 5,
              skills: ["Swift", "SwiftUI"]),
        Person(name: "Laura Bracale", isFavorite: false, details: "Graphic Designer",
              dob: Calendar.current.date(byAdding: .year, value: -28, to: Date())!,
              sex: "Female", contact: "laura@example.com", experience: 4,
              skills: ["Figma", "Sketch"]),
        Person(name: "Dyuthi Kuchu", isFavorite: false, details: "Product Manager",
              dob: Calendar.current.date(byAdding: .year, value: -32, to: Date())!,
              sex: "Female", contact: "dyuthi@example.com", experience: 7,
              skills: ["Agile", "Scrum"]),
        Person(name: "Mario Manzini", isFavorite: false, details: "UX Researcher",
              dob: Calendar.current.date(byAdding: .year, value: -35, to: Date())!,
              sex: "Male", contact: "mario@example.com", experience: 8,
              skills: ["User Testing", "Interviews"])
    ]
    
    func toggleFavorite(for person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people[index].isFavorite.toggle()
        }
    }
    
    // Sorting functions
    func sortByName() {
        people.sort { $0.name < $1.name }
    }
    
    func sortByFavorite() {
        people.sort { $0.isFavorite && !$1.isFavorite }
    }
}
