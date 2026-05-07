import SwiftUI
import SwiftData

@main
struct SoftLoudApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Alarm.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var viewModel = AlarmListViewModel()

    var body: some Scene {
        WindowGroup {
            AlarmListView()
                .environment(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
