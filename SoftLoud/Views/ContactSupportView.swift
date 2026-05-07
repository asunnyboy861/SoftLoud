import SwiftUI

struct ContactSupportView: View {
    @State private var message = ""
    @State private var showSuccess = false

    private let supportEmail = "zzoutuo@gmail.com"

    var body: some View {
        Form {
            Section("Send us a message") {
                TextField("Subject", text: .constant("SoftLoud Support"))
                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }

            Section {
                Button {
                    sendEmail()
                } label: {
                    HStack {
                        Spacer()
                        Text("Send via Email")
                            .font(.headline)
                        Spacer()
                    }
                }
                .disabled(message.isEmpty)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Email Client Opened", isPresented: $showSuccess) {
            Button("OK") { }
        } message: {
            Text("Your email client has been opened with the support email address.")
        }
    }

    private func sendEmail() {
        let subject = "SoftLoud Support"
        let body = message.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        let urlString = "mailto:\(supportEmail)?subject=\(subject)&body=\(body)"

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
            showSuccess = true
        }
    }
}
