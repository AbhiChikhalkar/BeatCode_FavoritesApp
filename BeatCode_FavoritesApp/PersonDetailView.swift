//
//  PersonDetailView.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        VStack {
            Text(person.name)
                .font(.title)
            Text(person.details)
                .foregroundColor(.secondary)
            
            // Basic info section
            VStack(alignment: .leading) {
                Text("Age: \(person.age)")
                Text("DOB: \(person.formattedDOB)")
                Text("Contact: \(person.contact)")
            }
            .padding()
            
            // Simple skills list
            VStack(alignment: .leading) {
                Text("Skills:")
                ForEach(person.skills, id: \.self) { skill in
                    Text("• \(skill)")
                }
            }
        }
        .padding()
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailView(person: Person.sample)
    }
}