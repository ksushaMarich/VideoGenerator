

import Foundation
import StoreKit
import ApphudSDK

struct SubscriptionOption: Identifiable, Hashable {
    let product: ApphudProduct
    let title: String
    let weeklyPrice: String
    let fullPrice: String
    let savingsPercent: Int?

    var id: String {
        product.productId
    }
}

enum SubscriptionOptionBuilder {

    private struct Item {
        let apphudProduct: ApphudProduct
        let storeProduct: Product
        let weeklyPrice: Decimal
    }

    static func build(
        from products: [(apphud: ApphudProduct, store: Product)]
    ) -> [SubscriptionOption] {

        let items: [Item] = products.compactMap { item -> Item?  in
            guard let subscription = item.store.subscription else {
                return nil
            }

            let period = subscription.subscriptionPeriod
            let weeks: Decimal

            switch period.unit {
            case .day:
                weeks = Decimal(period.value) / 7
            case .week:
                weeks = Decimal(period.value)
            case .month:
                weeks = Decimal(period.value) * 52 / 12
            case .year:
                weeks = Decimal(period.value) * 52
            @unknown default:
                return nil
            }

            guard weeks > 0 else { return nil }
            
            return Item(
                apphudProduct: item.apphud,
                storeProduct: item.store,
                weeklyPrice: period.unit == .week ? item.store.price : item.store.price / weeks
            )
        }

        guard let highestWeeklyPrice = items.map(\.weeklyPrice).max() else {
            return []
        }

        return items.sorted {
            $0.weeklyPrice < $1.weeklyPrice
        }.map { item in
            let savingsPercent: Int?

            if item.weeklyPrice < highestWeeklyPrice {
                let savings = (
                    1 - item.weeklyPrice / highestWeeklyPrice
                ) * 100

                savingsPercent = NSDecimalNumber(decimal: savings)
                    .rounding(accordingToBehavior: nil)
                    .intValue
            } else {
                savingsPercent = nil
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            let formattedPrice = formatter.string(
                from: NSDecimalNumber(decimal: item.weeklyPrice)
            ) ?? "Formatting failed"

            
            print("End \(formattedPrice)")
            
            return SubscriptionOption(
                product: item.apphudProduct,
                title: periodTitle(
                    item.storeProduct.subscription?.subscriptionPeriod
                ),
                weeklyPrice: formattedPrice,
                fullPrice: item.storeProduct.displayPrice,
                savingsPercent: savingsPercent
            )
        }
    }

    private static func periodTitle(
        _ period: Product.SubscriptionPeriod?
    ) -> String {
        guard let period else { return "Subscription" }

        switch period.unit {
        case .day:
            return period.value == 1 ? "Day" : "\(period.value) Days"
        case .week:
            return period.value == 1 ? "Week" : "\(period.value) Weeks"
        case .month:
            return period.value == 1 ? "Month" : "\(period.value) Months"
        case .year:
            return period.value == 1 ? "Year" : "\(period.value) Years"
        @unknown default:
            return "Subscription"
        }
    }
}

