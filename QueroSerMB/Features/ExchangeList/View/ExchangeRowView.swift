//
//  ExchangeRowView.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import SwiftUI

struct ExchangeRowView: View {
    let exchange: Exchange
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: exchange.logo)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 40, height: 40)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exchange.name)
                    .font(.headline)
                
                if let date = exchange.dateLaunched {
                    Text("Desde \(date.prefix(4))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let volume = exchange.spotVolumeUsd {
                Text(volume.formatted(.currency(code: "USD")))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}
