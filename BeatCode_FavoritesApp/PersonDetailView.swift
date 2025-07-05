//
//  PersonDetailView.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//

import SwiftData
import SwiftUI

struct PersonDetailView: View {
    @Bindable var person: Person
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Text(person.initials)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.top, 30)
                
                // Info Section
                VStack(alignment: .leading, spacing: 15) {
                    Text(person.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(person.details)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    DetailRow(icon: "calendar", label: "Age", value: "\(person.age) years")
                    DetailRow(icon: "birthday.cake", label: "DOB", value: person.formattedDOB)
                    DetailRow(icon: "person.fill", label: "Sex", value: person.sex)
                    DetailRow(icon: "mail", label: "Contact", value: person.contact)
                    
                    // Experience
                    HStack {
                        Image(systemName: "briefcase")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        Text("Experience")
                        Spacer()
                        Text("\(person.experience) years")
                            .foregroundColor(.secondary)
                    }
                    
                    // Skills
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "laptopcomputer")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Skills")
                            Spacer()
                        }
                        
                        FlexibleView(data: person.skills, spacing: 8, alignment: .leading) { skill in
                            Text(skill)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Favorite Button
                Button {
                    person.isFavorite.toggle()
                } label: {
                    HStack {
                        Image(systemName: person.isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                        Text(person.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                            .font(.headline)
                    }
                    .foregroundColor(person.isFavorite ? .white : .pink)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(person.isFavorite ? Color.pink : Color.pink.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .accessibilityLabel(person.isFavorite ? "Remove from favorites" : "Add to favorites")
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddEditPersonView(person: person)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}

// MARK: - Helper Views

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            _FlexibleView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth -= (elementSize.width + spacing)
        }
        
        return rows
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// Preview Provider
struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Person.self, configurations: config)
        
        let samplePerson = Person(
            name: "Abhi Chikhalkar",
            isFavorite: false,
            details: "ios Developer",
            dob: Date(),
            sex: "Male",
            contact: "AbhiChikhalkar@example.com",
            experience: 5,
            skills: ["Swift", "SwiftUI", "Combine"]
        )
        
        return NavigationStack {
            PersonDetailView(person: samplePerson)
        }
        .modelContainer(container)
    }
}
