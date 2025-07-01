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
            List(viewModel.people) { person in
                NavigationLink {
                    PersonDetailView(person: person)
                } label: {
                    Text(person.name)
                }
            }
            .navigationTitle("People")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
