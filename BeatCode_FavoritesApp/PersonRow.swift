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
        let rowContent = HStack(spacing: 16) {
            if isEditing {
                editMenu
            }
            
            profileInitials
            
            personInfo
            
            Spacer()
            
            favoriteButton
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        
        ZStack {
            NavigationLink {
                PersonDetailView(person: person)
            } label: {
                EmptyView()
            }
            .opacity(0)
            .accessibilityHidden(true)
            
            rowContent
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(person.name), \(person.details)")
        .accessibilityHint("Double tap to view details")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: person.isFavorite ? "Remove from favorites" : "Add to favorites") {
            viewModel.toggleFavorite(for: person)
        }
        .buttonStyle(.plain)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .listRowBackground(person.isFavorite ? Color.pink.opacity(0.1) : Color.clear)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if !isEditing {
                Button {
                    showingEditSheet = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .accessibilityLabel("Edit \(person.name)")
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
                .accessibilityLabel("Delete \(person.name)")
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditPersonView(person: person)
        }
    }
    
    private var editMenu: some View {
        Menu {
            Button {
                showingEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .accessibilityLabel("Edit \(person.name)")
            
            Button(role: .destructive) {
                viewModel.deletePerson(person)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .accessibilityLabel("Delete \(person.name)")
        } label: {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 20))
        }
        .accessibilityLabel("Actions for \(person.name)")
        .padding(.trailing, 8)
    }
    
    private var profileInitials: some View {
        Circle()
            .fill(Color.blue.opacity(0.2))
            .frame(width: 48, height: 48)
            .overlay(
                Text(person.initials)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
            )
            .accessibilityHidden(true)
    }
    
    private var personInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(person.name)
                .font(.headline)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
            
            Text(person.details)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var favoriteButton: some View {
        Button {
            viewModel.toggleFavorite(for: person)
        } label: {
            Image(systemName: person.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(person.isFavorite ? .red : .gray)
                .font(.system(size: 20))
        }
        .accessibilityHidden(true) // Handled by the accessibilityAction
        .buttonStyle(.plain)
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
        
        return Group {
            PersonRow(person: samplePerson, isEditing: false)
                .environmentObject(viewModel)
                .previewDisplayName("Normal")
            
            PersonRow(person: samplePerson, isEditing: true)
                .environmentObject(viewModel)
                .previewDisplayName("Editing")
            
            PersonRow(person: Person(
                name: "Laura Bracale",
                isFavorite: true,
                details: "Designer",
                dob: Date(),
                sex: "Female",
                contact: "laura@example.com",
                experience: 4,
                skills: ["Figma"]
            ), isEditing: false)
            .environmentObject(viewModel)
            .previewDisplayName("Favorite")
        }
        .modelContainer(container)
    }
}
