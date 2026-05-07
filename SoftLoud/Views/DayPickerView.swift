import SwiftUI

struct DayPickerView: View {
    @Binding var selectedDays: [Int]
    private let daySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...7, id: \.self) { day in
                let symbol = String(daySymbols[day - 1].prefix(2))
                let isSelected = selectedDays.contains(day)

                Button {
                    toggleDay(day)
                } label: {
                    Text(symbol)
                        .font(.caption.bold())
                        .foregroundStyle(isSelected ? .white : .secondary)
                        .frame(width: 36, height: 36)
                        .background(isSelected ? Color.orange : Color(.systemGray6))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func toggleDay(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
            selectedDays.sort()
        }
    }
}
