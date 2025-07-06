//
//  PersonRow.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//

import SwiftData
import SwiftUI

struct PersonRow: View {
    @EnvironmentObject var viewModel: PeopleViewModel
    @Bindable var person: Person
    let isEditing: Bool
    @State private var showingEditSheet = false
    
    var body: some View {
        NavigationLink {
            PersonDetailView(person: person)
        } label: {
            HStack(spacing: 16) {
                if isEditing {
                    Menu {
                        Button {
                            showingEditSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deletePerson(person)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    .padding(.trailing, 8)
                }
                // Profile Initials
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(person.initials)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(person.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(person.details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Favorite Button
                Button {
                    viewModel.toggleFavorite(for: person)
                } label: {
                    Image(systemName: person.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(person.isFavorite ? .red : .gray)
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .listRowBackground(Color.clear)
        
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if !isEditing {
                Button {
                    showingEditSheet = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.blue)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if !isEditing {
                Button(role: .destructive) {
                    viewModel.deletePerson(person)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditPersonView(person: person)
        }
        .listRowBackground(person.isFavorite ? Color.pink.opacity(0.1) : Color.clear)
    }
       }
    
struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Person.self, configurations: config)
        let context = container.mainContext
        let viewModel = PeopleViewModel(modelContext: context)
        
        let samplePerson = Person(
            name: "Abhi Chikhalkar",
            isFavorite: false,
            details: "iOS Developer",
            dob: Date(),
            sex: "Male",
            contact: "AbhiChikhalkar@example.com",
            experience: 5,
            skills: ["Swift", "SwiftUI"]
        )
        
        return PersonRow(person: samplePerson, isEditing: false)
            .environmentObject(viewModel)
            .modelContainer(container)
    }
}
