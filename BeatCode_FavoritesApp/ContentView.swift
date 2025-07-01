//
//  ContentView.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PeopleViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Favorites") {
                    ForEach(viewModel.people.filter { $0.isFavorite }) { person in
                        PersonRow(person: person, viewModel: viewModel)
                    }
                }
                
                Section("All People") {
                    ForEach(viewModel.people.filter { !$0.isFavorite }) { person in
                        PersonRow(person: person, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("People")
        }
    }
}

struct PersonRow: View {
    let person: Person
    @ObservedObject var viewModel: PeopleViewModel
    
    var body: some View {
        NavigationLink {
            PersonDetailView(viewModel: viewModel, person: person)
        } label: {
            HStack {
                Text(person.name)
                Spacer()
                if person.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
