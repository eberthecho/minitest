import SwiftUI

struct ProductCardView: View {
    @State private var product = Product.placeholder

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: product.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundStyle(.tint)
                    .padding(.top, 32)

                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(product.price)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text(product.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 24)

                Spacer(minLength: 24)

                Link(destination: product.fullSiteURL) {
                    Text("Открыть на сайте")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(.tint)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct Product {
    let sku: String
    let name: String
    let description: String
    let price: String
    let iconName: String
    let fullSiteURL: URL

    static let placeholder = Product(
        sku: "DEMO-001",
        name: "Премиум товар",
        description: "Это карточка товара открытая через NFC. Здесь будет качественное описание, спецификации и преимущества. Полная информация — на сайте.",
        price: "12 990 ₽",
        iconName: "cube.box.fill",
        fullSiteURL: URL(string: "https://example.com/p/DEMO-001")!
    )
}

#Preview {
    ProductCardView()
}
