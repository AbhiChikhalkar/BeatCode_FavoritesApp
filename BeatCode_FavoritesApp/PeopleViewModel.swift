//
//  PeopleViewModel.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = [Person.sample]
    
    func toggleFavorite(for person: Person) {
       
    }
}
