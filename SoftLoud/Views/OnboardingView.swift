import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            welcomePage.tag(0)
            volumePage.tag(1)
            permissionPage.tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange)

            Text("SoftLoud")
                .font(.largeTitle.bold())

            Text("Your alarm volume,\nindependent at last.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Spacer()

            nextButton
        }
        .padding()
    }

    private var volumePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 72))
                .foregroundStyle(.orange)

            Text("Independent Volume")
                .font(.title.bold())

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundStyle(.secondary)
                    Text("Ringer Volume")
                    Spacer()
                    Text("30%")
                        .foregroundStyle(.green)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundStyle(.secondary)
                    Text("Alarm Volume")
                    Spacer()
                    Text("80%")
                        .foregroundStyle(.orange)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Text("Each alarm has its own volume.\nNo more oversleeping because you\nturned down your ringer.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Spacer()

            nextButton
        }
        .padding()
    }

    private var permissionPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "bell.badge.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange)

            Text("Notifications")
                .font(.title.bold())

            Text("SoftLoud needs notification permission\nto deliver alarms reliably.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                Task {
                    _ = await AlarmScheduler.shared.requestNotificationPermission()
                    AlarmScheduler.shared.setupNotificationCategories()
                    onComplete()
                }
            } label: {
                Text("Allow Notifications")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)

            Button("Skip") {
                onComplete()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 20)
        }
        .padding()
    }

    private var nextButton: some View {
        Button {
            withAnimation { currentPage += 1 }
        } label: {
            Text("Next")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}
