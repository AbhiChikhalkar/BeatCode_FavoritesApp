//
//  PersonRow.swift
//  BeatCode
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI

struct PersonRow: View {
    let person: Person
    let viewModel: PeopleViewModel
    let isEditing: Bool
    
    var body: some View {
        NavigationLink {
            PersonDetailView(viewModel: viewModel, person: person)
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
            .padding(.vertical, 8)
        }
        .listRowBackground(person.isFavorite ? Color.pink.opacity(0.1) : Color.clear)
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = PeopleViewModel()
        let mockPerson = mockViewModel.people[0]
        
        Group {
            PersonRow(person: mockPerson, viewModel: mockViewModel, isEditing: false)
            PersonRow(person: mockPerson, viewModel: mockViewModel, isEditing: true)
        }
        .previewLayout(.sizeThatFits)
    }
}
