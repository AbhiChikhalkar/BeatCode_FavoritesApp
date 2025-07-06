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
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    
    var body: some View {
           ScrollView {
               VStack(spacing: 0) {
                   ZStack(alignment: .topTrailing) {
                       LinearGradient(
                           gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
                       )
                       .frame(height: 220)
                       .overlay(
                           Text(person.initials)
                               .font(.system(size: 80, weight: .bold))
                               .foregroundColor(.blue.opacity(0.15))
                       )
                       .accessibilityHidden(true)
                       
                       VStack(alignment: .leading, spacing: 8) {
                           Spacer()
                           
                           Text(person.name)
                               .font(.system(size: 28, weight: .bold))
                               .lineLimit(2)
                               .minimumScaleFactor(0.8)
                               .accessibilityAddTraits(.isHeader)
                           
                           Text(person.details)
                               .font(.title3)
                               .foregroundColor(.secondary)
                       }
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.horizontal, 20)
                       .padding(.bottom, 60)
                   }
                   .accessibilityElement(children: .combine)
                   .accessibilityLabel("\(person.name), \(person.details)")
                   
                   VStack(alignment: .leading, spacing: 20) {
                       VStack(alignment: .leading, spacing: 12) {
                           Text("Personal Information")
                               .font(.headline)
                               .foregroundColor(.blue)
                               .accessibilityAddTraits(.isHeader)
                           
                           Divider()
                               .accessibilityHidden(true)
                           
                           DetailRow(icon: "calendar", label: "Age", value: "\(person.age) years")
                           DetailRow(icon: "birthday.cake", label: "Date of Birth", value: person.formattedDOB)
                           DetailRow(icon: "person.fill", label: "Gender", value: person.sex)
                           DetailRow(icon: "envelope", label: "Contact", value: person.contact)
                       }
                       .accessibilityElement(children: .contain)
                       .accessibilityLabel("Personal information")
                       
                       VStack(alignment: .leading, spacing: 12) {
                           Text("Professional Information")
                               .font(.headline)
                               .foregroundColor(.blue)
                               .accessibilityAddTraits(.isHeader)
                           
                           Divider()
                               .accessibilityHidden(true)
                           
                           DetailRow(icon: "briefcase", label: "Experience", value: "\(person.experience) years")
                           
                           VStack(alignment: .leading, spacing: 8) {
                               Text("Skills")
                                   .font(.subheadline)
                                   .foregroundColor(.primary)
                               
                               FlexibleView(
                                   data: person.skills,
                                   spacing: 8,
                                   alignment: .leading
                               ) { skill in
                                   Text(skill)
                                       .padding(.horizontal, 12)
                                       .padding(.vertical, 6)
                                       .font(.caption)
                                       .background(Capsule().fill(Color.blue.opacity(0.1)))
                                       .foregroundColor(.blue)
                               }
                               .accessibilityElement(children: .combine)
                               .accessibilityLabel("Skills: \(person.skills.joined(separator: ", "))")
                           }
                       }
                       .accessibilityElement(children: .contain)
                       .accessibilityLabel("Professional information")
                       
                       Button {
                           person.isFavorite.toggle()
                       } label: {
                           HStack {
                               Image(systemName: person.isFavorite ? "heart.fill" : "heart")
                                   .font(.title2)
                               Text(person.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                   .font(.headline)
                           }
                           .frame(maxWidth: .infinity)
                           .padding(.vertical, 12)
                           .background(
                               Capsule()
                                   .fill(person.isFavorite ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                           )
                       }
                       .accessibilityLabel(person.isFavorite ? "Remove from favorites" : "Add to favorites")
                       .accessibilityHint("Double tap to toggle favorite status")
                       .foregroundColor(person.isFavorite ? .red : .primary)
                       .padding(.top, 8)
                   }
                   .padding(20)
                   .background(Color(.systemBackground))
                   .cornerRadius(16)
                   .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                   .padding(.horizontal, 16)
                   .offset(y: -30)
                   .zIndex(1)
               }
               .padding(.bottom, 20)
           }
           .background(Color(.systemGroupedBackground))
           .ignoresSafeArea(edges: .top)
           .navigationBarTitleDisplayMode(.inline)
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button {
                       dismiss()
                   } label: {
                       Image(systemName: "xmark.circle.fill")
                           .font(.title2)
                           .symbolRenderingMode(.hierarchical)
                           .foregroundColor(.gray)
                   }
                   .accessibilityLabel("Close")
               }
           }
           .onAppear {
               withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                   isAnimating = true
               }
           }
       }
   }

// MARK: - Detail row
   struct DetailRow: View {
       let icon: String
       let label: String
       let value: String
       
       var body: some View {
           HStack(alignment: .top, spacing: 12) {
               Image(systemName: icon)
                   .frame(width: 24, alignment: .center)
                   .foregroundColor(.blue)
                   .accessibilityHidden(true)
               
               VStack(alignment: .leading, spacing: 2) {
                   Text(label)
                       .font(.subheadline)
                       .foregroundColor(.secondary)
                       .accessibilityHidden(true)
                   
                   Text(value)
                       .font(.body)
                       .foregroundColor(.primary)
               }
               .accessibilityElement(children: .combine)
               .accessibilityLabel("\(label): \(value)")
               
               Spacer()
           }
           .padding(.vertical, 6)
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
