import Foundation

struct VolumePreset: Identifiable, Codable {
    let id: UUID
    var name: String
    var volume: Float
    var isGradual: Bool
    var gradualDuration: Int
    var icon: String

    static let builtIn: [VolumePreset] = [
        VolumePreset(
            id: UUID(),
            name: "Gentle Wake",
            volume: 0.3,
            isGradual: true,
            gradualDuration: 60,
            icon: "sunrise.fill"
        ),
        VolumePreset(
            id: UUID(),
            name: "Normal",
            volume: 0.7,
            isGradual: false,
            gradualDuration: 0,
            icon: "speaker.wave.2.fill"
        ),
        VolumePreset(
            id: UUID(),
            name: "Loud & Clear",
            volume: 1.0,
            isGradual: true,
            gradualDuration: 15,
            icon: "speaker.wave.3.fill"
        ),
        VolumePreset(
            id: UUID(),
            name: "Earthquake",
            volume: 1.0,
            isGradual: false,
            gradualDuration: 0,
            icon: "exclamationmark.triangle.fill"
        )
    ]
}
