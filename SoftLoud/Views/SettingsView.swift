import SwiftUI

struct SettingsView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false

    var body: some View {
        List {
            aboutSection
            supportSection
            resetSection
        }
        .navigationTitle("Settings")
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("SoftLoud")
                    .font(.headline)
                Spacer()
                Text("v1.0")
                    .foregroundStyle(.secondary)
            }

            LabeledContent("Made by", value: "zzoutuo")
        } header: {
            Text("About")
        }
    }

    private var supportSection: some View {
        Section {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope.fill")
            }

            Link(
                destination: URL(string: "https://zzoutuo.github.io/SoftLoud/privacy")!
            ) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }
        } header: {
            Text("Support")
        }
    }

    private var resetSection: some View {
        Section {
            Button("Reset Onboarding", role: .destructive) {
                hasLaunchedBefore = false
            }
        } header: {
            Text("Debug")
        } footer: {
            Text("SoftLoud — Your alarm volume, independent at last.")
        }
    }
}
