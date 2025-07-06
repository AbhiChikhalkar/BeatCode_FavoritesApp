//
//  PeopleViewModel.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftData
import SwiftUI

@MainActor
final class PeopleViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published private(set) var people: [Person] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadPeople()
        
        if people.isEmpty {
            addSampleData()
        }
    }
    
    private func loadPeople() {
        do {
            let descriptor = FetchDescriptor<Person>()
            people = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch people: \(error)")
        }
    }
    
    private func addSampleData() {
        let samplePeople = [
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
        
        samplePeople.forEach { modelContext.insert($0) }
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
            loadPeople()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
            
            // Public interface
            func getAllPeople() -> [Person] {
                return people
            }
            
            func getFavorites() -> [Person] {
                return people.filter { $0.isFavorite }
            }
            
            func getNonFavorites() -> [Person] {
                return people.filter { !$0.isFavorite }
            }
            
            func addPerson(name: String, details: String, dob: Date, sex: String,
                          contact: String, experience: Int, skills: [String]) {
                let newPerson = Person(name: name, isFavorite: false, details: details,
                                     dob: dob, sex: sex, contact: contact,
                                     experience: experience, skills: skills)
                modelContext.insert(newPerson)
                saveChanges()
            }
            
            func updatePerson(person: Person, name: String, details: String, dob: Date,
                             sex: String, contact: String, experience: Int, skills: [String]) {
                person.name = name
                person.details = details
                person.dob = dob
                person.sex = sex
                person.contact = contact
                person.experience = experience
                person.skills = skills
                saveChanges()
            }
            
            func deletePerson(_ person: Person) {
                modelContext.delete(person)
                saveChanges()
            }
            
            func toggleFavorite(for person: Person) {
                person.isFavorite.toggle()
                saveChanges()
            }
            
            func sortByName() {
                people.sort { $0.name < $1.name }
            }
            
            func sortByFavorite() {
                people.sort { $0.isFavorite && !$1.isFavorite }
            }
        }
