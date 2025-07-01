import SwiftUI

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = [Person.sample]
    
    func toggleFavorite(for person: Person) {
        // Implementation will be added in later steps
    }
}