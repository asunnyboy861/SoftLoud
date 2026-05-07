import SwiftUI

struct AlarmRingingView: View {
    let onDismiss: () -> Void
    let onSnooze: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Image(systemName: "alarm.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.orange)
                    .scaleEffect(pulseScale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                        ) {
                            pulseScale = 1.2
                        }
                    }

                Text("Alarm")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Spacer()

                VStack(spacing: 16) {
                    Button {
                        onDismiss()
                    } label: {
                        Text("Dismiss")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                        onSnooze()
                    } label: {
                        Text("Snooze")
                            .font(.headline)
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 60)
            }
        }
    }
}
