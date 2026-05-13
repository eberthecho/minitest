import SwiftUI

struct AppContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text("Каталог товаров")
                .font(.largeTitle.bold())
            Text("Полное приложение будет здесь.\nПока — приложите телефон к NFC-метке товара.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    AppContentView()
}
