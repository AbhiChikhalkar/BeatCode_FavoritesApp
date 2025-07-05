//
//
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 01/07/25.
//


import SwiftUI
import SwiftData

@main
struct BeatCodeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Person.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    PeopleViewModel(modelContext: sharedModelContainer.mainContext)
                )
                .modelContainer(sharedModelContainer)
        }
    }
}
