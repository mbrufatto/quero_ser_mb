//
//  ExchangeDetailView.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import SwiftUI

struct ExchangeDetailView: View {
    @ObservedObject var viewModel: ExchangeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: viewModel.exchange.logo)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.exchange.name)
                            .font(.title)
                            .bold()
                        Text("ID: \(viewModel.exchange.id)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let description = viewModel.exchange.description {
                    Text("Sobre")
                        .font(.headline)
                    Text(description)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    infoRow(label: "Website", value: viewModel.exchange.urls?.website?.first ?? "N/A", isLink: true)
                    infoRow(label: "Lançamento", value: viewModel.exchange.dateLaunched ?? "N/A")
                    infoRow(label: "Maker Fee", value: String(format: "%.2f%%", viewModel.exchange.makerFee ?? 0.0))
                    infoRow(label: "Taker Fee", value: String(format: "%.2f%%", viewModel.exchange.takerFee ?? 0.0))
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                if viewModel.currencies.isEmpty {
                    Text("Não há moedas disponíveis")
                        .font(.headline)
                        .padding(.top)
                        .foregroundStyle(.red)
                } else {
                    Text("Moedas Disponíveis")
                        .font(.headline)
                        .padding(.top)
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    LazyVStack {
                        ForEach(viewModel.currencies) { currency in
                            CurrencyRow(currency: currency.currency)
                            Divider()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.exchange.name)
        .task {
            await viewModel.loadCurrencies()
        }
    }
    
    @ViewBuilder
    private func infoRow(label: String, value: String, isLink: Bool = false) -> some View {
        HStack {
            Text("\(label): ")
                .bold()
            Spacer()
            if isLink, let url = URL(string: value) {
                Link(value, destination: url)
                    .lineLimit(1)
            } else {
                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
        .font(.subheadline)
    }
}
