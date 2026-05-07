import SwiftUI

struct VolumePresetButton: View {
    let preset: VolumePreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: preset.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : .orange)

                Text(preset.name)
                    .font(.caption2.bold())
                    .foregroundStyle(isSelected ? .white : .primary)

                Text("\(Int(preset.volume * 100))%")
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .frame(width: 72, height: 72)
            .background(isSelected ? Color.orange : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
