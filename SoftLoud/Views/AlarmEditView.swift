import SwiftUI
import SwiftData

enum AlarmEditMode {
    case create
    case edit(Alarm)
}

struct AlarmEditView: View {
    let mode: AlarmEditMode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AlarmEditViewModel()

    var body: some View {
        NavigationStack {
            Form {
                timeSection
                volumeSection
                soundSection
                gradualSection
                snoozeSection
                repeatSection
                labelSection
            }
            .navigationTitle(viewModel.isNewAlarm ? "New Alarm" : "Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            var alarm: Alarm?
            if case .edit(let a) = mode {
                alarm = a
            }
            viewModel.setup(modelContext: modelContext, alarm: alarm)
        }
    }

    private var timeSection: some View {
        Section {
            DatePicker(
                "Time",
                selection: $viewModel.time,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }

    private var volumeSection: some View {
        Section {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundStyle(.secondary)
                    Slider(
                        value: $viewModel.volume,
                        in: 0...1,
                        step: 0.01
                    ) {
                        Text("Volume")
                    }
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundStyle(.secondary)
                }

                Text("\(Int(viewModel.volume * 100))%")
                    .font(.title2.bold())
                    .foregroundStyle(volumeColor)
                    .contentTransition(.numericText())
            }
            .padding(.vertical, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.presets) { preset in
                        VolumePresetButton(
                            preset: preset,
                            isSelected: viewModel.selectedPreset?.id == preset.id
                        ) {
                            viewModel.applyPreset(preset)
                        }
                    }
                }
            }
        } header: {
            Text("Independent Volume")
        } footer: {
            Text("This volume is independent from your iPhone ringer volume.")
        }
    }

    private var soundSection: some View {
        Section("Sound") {
            Picker("Sound", selection: $viewModel.soundName) {
                ForEach(viewModel.availableSounds, id: \.self) { sound in
                    Text(sound).tag(sound)
                }
            }
        }
    }

    private var gradualSection: some View {
        Section("Gradual Volume") {
            Toggle("Gradual Wake", isOn: $viewModel.isGradual)
            if viewModel.isGradual {
                Stepper(
                    "Ramp up: \(viewModel.gradualDuration)s",
                    value: $viewModel.gradualDuration,
                    in: 10...120,
                    step: 10
                )
            }
        }
    }

    private var snoozeSection: some View {
        Section("Snooze") {
            Toggle("Enable Snooze", isOn: $viewModel.snoozeEnabled)
            if viewModel.snoozeEnabled {
                Stepper(
                    "Duration: \(viewModel.snoozeDuration) min",
                    value: $viewModel.snoozeDuration,
                    in: 1...30,
                    step: 1
                )
            }
        }
    }

    private var repeatSection: some View {
        Section("Repeat") {
            DayPickerView(selectedDays: $viewModel.repeatDays)
        }
    }

    private var labelSection: some View {
        Section("Label") {
            TextField("Alarm Label", text: $viewModel.label)
        }
    }

    private var volumeColor: Color {
        if viewModel.volume < 0.3 { return .green }
        if viewModel.volume < 0.7 { return .orange }
        return .red
    }
}
