//
//  CurrencyRow.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import SwiftUI

struct CurrencyRow: View {
    let currency: Currency
    
    var body: some View {
        HStack {
            Text(currency.name)
                .font(.body)
            Spacer()
            Text(currency.priceUSD.formatted(.currency(code: "USD")))
                .font(.body)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}
