//
//  ContentView.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PeopleViewModel
    @State private var showingAddSheet = false
    @State private var editMode: EditMode = .inactive
    @State private var isEditing = false
    @State private var searchText = ""
    
    var filteredPeople: [Person] {
        if searchText.isEmpty {
            return viewModel.people
        } else {
            return viewModel.people.filter { person in
                person.name.localizedCaseInsensitiveContains(searchText) ||
                person.details.localizedCaseInsensitiveContains(searchText) ||
                person.contact.localizedCaseInsensitiveContains(searchText) ||
                person.skills.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Favorites") {
                    ForEach(filteredPeople.filter { $0.isFavorite }) { person in
                        PersonRow(person: person, isEditing: isEditing)
                    }
                    .onDelete { indexSet in
                        deletePeople(at: indexSet, fromFavorites: true)
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Favorites")
                
                Section("All People") {
                    ForEach(filteredPeople.filter { !$0.isFavorite }) { person in
                        PersonRow(person: person, isEditing: isEditing)
                    }
                    .onDelete { indexSet in
                        deletePeople(at: indexSet, fromFavorites: false)
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel("All People")
            }
            .accessibilityLabel("People list")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .accessibilityHint("Search for people by name, details, contact or skills")
            .navigationTitle("People")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { showingAddSheet = true }) {
                        Label("Add", systemImage: "plus")
                    }
                    .accessibilityLabel("Add new person")
                    
                    Spacer()
                    
                    Button(action: { isEditing.toggle() }) {
                        Label(isEditing ? "Done" : "Edit", systemImage: isEditing ? "checkmark" : "pencil")
                    }
                    .accessibilityLabel(isEditing ? "Done editing" : "Edit list")
                    .accessibilityHint(isEditing ? "Tap to finish editing" : "Tap to edit the list")
                    
                    Spacer()
                    
                    Menu {
                        Button("Sort by Name") { viewModel.sortByName() }
                            .accessibilityLabel("Sort by name")
                        Button("Favorites First") { viewModel.sortByFavorite() }
                            .accessibilityLabel("Sort with favorites first")
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    .accessibilityLabel("Sort options")
                    .accessibilityHint("Tap to choose sorting options")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditPersonView()
            }
        }
    }
    
    private func deletePeople(at offsets: IndexSet, fromFavorites: Bool) {
        let people = fromFavorites ?
            filteredPeople.filter { $0.isFavorite } :
            filteredPeople.filter { !$0.isFavorite }
        
        for index in offsets {
            let person = people[index]
            viewModel.deletePerson(person)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Person.self, configurations: config)
        let context = container.mainContext
        let viewModel = PeopleViewModel(modelContext: context)
        
        return ContentView()
            .environmentObject(viewModel)
            .modelContainer(container)
    }
}

