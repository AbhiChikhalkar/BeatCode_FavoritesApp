//
//  PersonDetailView.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

struct PersonDetailView: View {
    @ObservedObject var viewModel: PeopleViewModel
    let person: Person
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile section
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 100, height: 100)
                    Text(person.initials)
                        .font(.title)
                }
                
                // Info sections
                VStack(alignment: .leading, spacing: 10) {
                    Text(person.name)
                        .font(.title)
                    Text(person.details)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Personal Info
                    InfoRow(icon: "calendar", label: "Age", value: "\(person.age)")
                    InfoRow(icon: "birthday.cake", label: "DOB", value: person.formattedDOB)
                    InfoRow(icon: "person.fill", label: "Sex", value: person.sex)
                    InfoRow(icon: "phone", label: "Contact", value: person.contact)
                    
                    Divider()
                    
                    // Professional Info
                    InfoRow(icon: "briefcase", label: "Experience", value: "\(person.experience) years")
                    
                    // Skills
                    VStack(alignment: .leading) {
                        Text("Skills:")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(person.skills, id: \.self) { skill in
                                    Text(skill)
                                        .padding(8)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Favorite Button
                Button {
                    viewModel.toggleFavorite(for: person)
                } label: {
                    Text(person.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(person.isFavorite ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Profile")
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PersonDetailView(
                viewModel: PeopleViewModel(),
                person: Person.sample
            )
        }
    }
}
