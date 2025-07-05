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
        HStack {
            // Red info button (only shown in edit mode)
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
            
            NavigationLink {
                PersonDetailView(person: person)
            } label: {
                HStack {
                    if isEditing {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.gray)
                            .accessibilityHidden(true)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .fontWeight(person.isFavorite ? .bold : .regular)
                        Text(person.details)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if !isEditing {
                        Button {
                            viewModel.toggleFavorite(for: person)
                        } label: {
                            Image(systemName: person.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(person.isFavorite ? .pink : .gray)
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(person.isFavorite ? "Remove from favorites" : "Add to favorites")
                    }
                }
            }
            .disabled(isEditing)
        }
        .padding(.vertical, 8)
        // Swipe actions (only active when NOT in edit mode)
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
