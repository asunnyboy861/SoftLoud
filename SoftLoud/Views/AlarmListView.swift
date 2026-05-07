import SwiftUI
import SwiftData

struct AlarmListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AlarmListViewModel()
    @State private var showAddAlarm = false
    @State private var editingAlarm: Alarm?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.alarms.isEmpty {
                    emptyState
                } else {
                    alarmList
                }
            }
            .navigationTitle("SoftLoud")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AlarmEditView(mode: .create)) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(item: $editingAlarm) { alarm in
                AlarmEditView(mode: .edit(alarm))
            }
            .fullScreenCover(isPresented: $viewModel.showOnboarding) {
                OnboardingView {
                    viewModel.completeOnboarding()
                }
            }
            .overlay {
                if viewModel.ringingAlarmId != nil {
                    AlarmRingingView(
                        onDismiss: { viewModel.dismissRingingAlarm() },
                        onSnooze: { viewModel.snoozeRingingAlarm() }
                    )
                }
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Alarms",
            systemImage: "alarm.fill",
            description: Text("Tap + to add your first alarm with independent volume")
        )
    }

    private var alarmList: some View {
        List {
            ForEach(viewModel.alarms) { alarm in
                AlarmRow(alarm: alarm) {
                    viewModel.toggleAlarm(alarm)
                }
                .onTapGesture {
                    editingAlarm = alarm
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteAlarm(alarm)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct AlarmRow: View {
    let alarm: Alarm
    let onToggle: () -> Void

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: alarm.time)
    }

    private var dayString: String {
        if alarm.repeatDays.isEmpty { return "" }
        let daySymbols = Calendar.current.shortWeekdaySymbols
        return alarm.repeatDays.compactMap { daySymbols[safe: $0 - 1] }.joined(separator: " ")
    }

    private var volumeIcon: String {
        if alarm.volume < 0.3 { return "speaker.fill" }
        if alarm.volume < 0.7 { return "speaker.wave.2.fill" }
        return "speaker.wave.3.fill"
    }

    private var volumeColor: Color {
        if alarm.volume < 0.3 { return .green }
        if alarm.volume < 0.7 { return .orange }
        return .red
    }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeString)
                    .font(.title2.bold())
                    .foregroundStyle(alarm.isEnabled ? .primary : .secondary)

                HStack(spacing: 6) {
                    Text(alarm.label)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if !dayString.isEmpty {
                        Text(dayString)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: volumeIcon)
                        .foregroundStyle(alarm.isEnabled ? volumeColor : .secondary)
                        .font(.caption)
                    Text("\(Int(alarm.volume * 100))%")
                        .font(.caption.bold())
                        .foregroundStyle(alarm.isEnabled ? volumeColor : .secondary)
                }

                if alarm.isGradual {
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.up.right")
                            .font(.caption2)
                        Text("\(alarm.gradualDuration)s")
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
            }

            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
