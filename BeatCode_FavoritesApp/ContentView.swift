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
                        for index in indexSet {
                            let person = filteredPeople.filter { $0.isFavorite }[index]
                            viewModel.deletePerson(person)
                        }
                    }
                }
                
                Section("All People") {
                    ForEach(filteredPeople.filter { !$0.isFavorite }) { person in
                        PersonRow(person: person, isEditing: isEditing)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let person = filteredPeople.filter { !$0.isFavorite }[index]
                            viewModel.deletePerson(person)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("People")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { showingAddSheet = true }) {
                        Label("Add", systemImage: "plus")
                    }
                    
                    Spacer()
                    
                    Button(action: { isEditing.toggle() }) {
                        Label(isEditing ? "Done" : "Edit", systemImage: isEditing ? "checkmark" : "pencil")
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Sort by Name") { viewModel.sortByName() }
                        Button("Favorites First") { viewModel.sortByFavorite() }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditPersonView()
            }
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

